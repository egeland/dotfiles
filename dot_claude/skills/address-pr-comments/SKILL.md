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

3. **Validate before acting (mandatory for every suggestion)**

   **Never apply a review suggestion blindly** — human, Copilot, bot, or otherwise. Treat every request to change code as a claim to disprove or confirm.

   For each unresolved comment that proposes a change (or implies one), run this gate **before** editing:

   1. **Restate the claim** in one line (what problem, what fix).
   2. **Gather evidence** — pick what fits; do enough to be sure:
      - Repro the claimed failure (minimal config, plan/apply, unit/test, runtime)
      - Check call sites / real env values (is the bad path reachable?)
      - Read tool/docs for the suggested API (does it actually enforce what they think?)
      - Compare error quality: current failure vs suggested failure (hard error vs warning?)
      - Note toolchain constraints (OpenTofu/Terraform version quirks, linter rules, CI)
   3. **Verdict**:
      - **Accept** — claim true, fix is minimal and correct → implement
      - **Reject** — claim false, fix ineffective, or worse than status quo → no code change
      - **Partial** — claim half-right; implement only the part that holds
      - **Uncertain** — after a honest try, still unclear → ask user (grill / clarify). Wrong fix is 5× worse than asking.
   4. **Show evidence** in the chat response **and** in the PR reply when rejecting or partially accepting. Prefer tables/quotes from actual tool output over prose.

   ### Red flags (extra skepticism)

   - Automated reviewers (`copilot-*`, bots) — same bar as humans; higher prior of slop
   - “Add a check/guard/validation” without proving the bad path is reachable
   - Cross-cutting “module-level” machinery for a config no env uses (YAGNI)
   - Suggestions that previously broke us (e.g. TF `variable` validation referencing other vars — illegal; `check` blocks that only **warn** and still allow apply)
   - Fixes that paper over symptoms or duplicate an existing hard failure with noise

   ### After the gate — action types

   - **Fix needed (accepted)**: Make the code change (prefer TDD when non-trivial), push, reply with commit hash + brief why
   - **By design / reject**: Reply with rationale + evidence; no code change
   - **Out of scope / pre-existing**: Reply noting not introduced by this PR
   - **Already fixed**: Reply with the commit hash that addressed it
   - **Uncertain**: Stop and ask the user before coding

4. **Reply to each comment** using the GitHub REST API via `gh api`:

   ```
   gh api -X POST /repos/OWNER/REPO/pulls/PR_NUM/comments/COMMENT_DATABASE_ID/replies -f body="Your reply here"
   ```

   - Use the comment's `databaseId` in the URL path
   - Reject/partial replies must include evidence (command output, call-site facts, doc behavior)
   - Batch replies using a shell function for efficiency:

     ```bash
     reply() {
       gh api -X POST /repos/OWNER/REPO/pulls/PR_NUM/comments/$1/replies -f body="$2" > /dev/null && echo "replied $1"
     }
     reply 3090771983 "Fixed in abc123 — description of change."
     reply 3090772001 "Rejected — evidence: …"
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
- **Do not implement until the validate gate passes (Accept or Partial)**
- If code changes are needed, commit and push before replying
- Group related fixes into a single commit where sensible
- Ask the user whether or not to rebase before pushing
- Prefer rejecting a bad suggestion with evidence over “fixing” to silence the bot
