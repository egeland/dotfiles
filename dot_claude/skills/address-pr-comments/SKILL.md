---
name: address-pr-comments
description: Review and address all unresolved PR review comments — reply to each and resolve the thread
---

Review and address all unresolved PR review comments on the current repo's PR.

## Arguments

$ARGUMENTS - The PR number to review (e.g. "313"). If not provided, detect from the current branch.

## Steps

1. **Find the PR**: If no PR number given, detect from current branch using `gh pr view --json number`.

2. **List unresolved threads**: Use GraphQL to find all unresolved review threads:

   ```
   gh api graphql -f query='{ repository(owner: "OWNER", name: "REPO") { pullRequest(number: NUM) { reviewThreads(first: 50) { nodes { id isResolved comments(first: 5) { nodes { databaseId author { login } body path line } } } } } } }' --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)'
   ```

3. **For each unresolved comment**, determine the appropriate action:
   - **If uncertain**: Use /grill-with-docs skill to interrogate user about what needs doing. It is 5x worse to implement the wrong fix than to ask the user for clarification.
   - **Fix needed**: Make the code change using the /tdd skill, then reply with the commit hash.
   - **By design**: Reply explaining the rationale
   - **Out of scope / pre-existing**: Reply noting it's not introduced by this PR
   - **Already fixed**: Reply with the commit hash that addressed it

4. **Reply to each comment** using the GitHub REST API via `gh api`:

   ```
   gh api -X POST /repos/OWNER/REPO/pulls/PR_NUM/comments/COMMENT_DATABASE_ID/replies -f body="Your reply here"
   ```

   - Use the comment's `databaseId` in the URL path
   - Batch replies using a shell function for efficiency:

     ```bash
     reply() {
       gh api -X POST /repos/OWNER/REPO/pulls/PR_NUM/comments/$1/replies -f body="$2" > /dev/null && echo "replied $1"
     }
     reply 3090771983 "Fixed in abc123 — description of change."
     reply 3090772001 "By design — explanation."
     ```

5. **Resolve each thread** after replying using GraphQL:

   ```bash
   resolve() {
     gh api graphql -f query="mutation { resolveReviewThread(input: {threadId: \"$1\"}) { thread { isResolved } } }" --jq '.data.resolveReviewThread.thread.isResolved' && echo "resolved $1"
   }
   resolve "PRRT_kwDOFpOycs57T660"
   ```

   - The thread ID comes from the `id` field in the GraphQL query results (step 2), NOT the `databaseId`

6. **Verify**: After processing all comments, re-run the unresolved threads query and check count is zero:

   ```
   gh api graphql -f query='{ repository(owner: "OWNER", name: "REPO") { pullRequest(number: NUM) { reviewThreads(first: 50) { nodes { isResolved } } } } }' --jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)] | length'
   ```

## Important

- Address ALL unresolved comments, not just the latest batch
- Reply AND resolve — both steps are required for each comment
- Do not resolve without replying first
- If code changes are needed, commit and push before replying
- Group related fixes into a single commit where sensible
- Ask the user whether or not to rebase before pushing
