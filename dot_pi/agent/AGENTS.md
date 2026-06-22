# Global Pi Agent Instructions

## Environment

- User is on a MacOS machine
- User uses `fish` shell
- User uses homebrew, with ~/Brewfile (read only, do not edit without explicit instructions from user)

## Core Workflow

- Never edit files in the `main` git branch. Always ensure you are either in a worktrunk/worktree or branch. If in doubt, ask!
- Requirements: always clarify requirements using the `grill-with-docs` skill before beginning any development.
- **TDD**: 1 test → implement → pass → repeat (no batching). Always trigger the `tdd` skill when developing code.
- **Confirm** destructive ops (`rm`, overwrites)
- **Rust**: prefer it; `cargo fmt` + `cargo clippy` pre-commit
- **Tests pass before commit**

## Response Style

- Code: accurate. Non-code: terse (fragments > sentences)
- Honest, direct. Challenge me if I'm wrong.
- No chatter. Accuracy over speed.
- Be extremely concise. Sacrifice grammar for the sake of concision.

## Tool Preferences

- Use the rtk tools > native tools. E.g. `rtk find`, `rtk grep`. They have `--help` available for learning syntax.
- GitHub: SSH, `gh` CLI for non-git ops
- Main branch worktrees: `wt switch --create` (not `git worktree`)
- Before editing files, check that the current branch is up to date with origin. Rebase if needed.
- Never change git repo remotes from `ssh` to `https`.
- Never switch from a git branch, worktrunk or worktree without user's express request

## GitHub Workflow

- Never use `git add -A`, add each edited file with `git add -a <file1> <file2>`

### Create PR + set automerge (squash)

Do NOT use `--squash` or `--merge-method` flags on `gh pr create` — they don't exist.

Step 1 — create the PR (body from file to avoid shell quoting issues):

```bash
gh pr create --title "feat: <description>" --body-file /tmp/pr-body.md
```

Step 2 — enable squash + automerge:

```bash
gh pr merge --squash --auto
```

Verify with:

```bash
gh pr view <number> --json state,autoMergeRequest,title,url
```

Confirm `autoMergeRequest.mergeMethod == "SQUASH"` and `state == "OPEN"` before reporting success.

## Thinking Rules

1. **Surface tradeoffs**: state assumptions; if multiple interpretations exist, present them; if something's unclear, ask.
2. **Simplicity first**: minimum code that solves the problem, nothing speculative. Rewrite 200→50 lines if needed.
3. **Surgical changes**: touch only what's needed; remove orphans your changes create; don't "improve" unrelated code.

## Execution

- Define **verifiable success criteria** before starting:
  - "Add validation" → write tests for invalid inputs
  - "Fix bug" → write test that reproduces it
  - "Refactor" → ensure tests pass before and after
- Multi-step tasks: state plan with verification checkpoints
- Check codebase first for answers. Use tools like gitnexus to understand relationships within the codebase.
- Research to ≥95% certainty, cite evidence

## Planning

- Grill the user when intent is unclear. Ask questions until a shared understanding is reached. Ask one question at a time; give recommended answer + evidence
- In git repos: maintain PLAN.md
