# Global Pi Agent Instructions

## Environment

- User is on a MacOS machine
- User uses `fish` shell
- User uses homebrew, with ~/Brewfile (read only, do not edit without explicit instructions from user)
- Only use English language.

## Core Workflow

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
- GitHub: SSH, `gh` CLI for non-git ops, `jj` for the actual version control.

### Version Control System (Jujutsu / `jj`)

Use **Jujutsu (`jj`)** for version control. **Do not use `git` commands.**
Reference: <https://docs.jj-vcs.dev/latest/git-comparison/>

#### Key Concepts

- **No Staging Area**: Changes are automatically committed to the working copy.
- **No "Current Branch"**: You work on anonymous commits; use **bookmarks** (like branches) only when needed.
- **Undo is Safe**: Use `jj undo` instead of destructive resets.
- Check `jj --help` for details. Update this VCS section with any learning, especially if a common operation is unclear.

## GitHub Workflow

- Always fetch and rebase before pushing to GitHub.

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

Confirm `autoMergeRequest.mergeMethod == "SQUASH"` and `state == "OPEN"` and that the branch doesn't require rebase before reporting success.

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
- Check codebase first for answers.
- Use tools like gitnexus to understand relationships within the codebase.
- Research to ≥95% certainty, cite evidence
