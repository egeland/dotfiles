# Global Pi Agent Instructions

## Coding rules

State assumptions explicitly. Ask rather than guess.
Push back when a simpler approach exists. Stop when confused.

Minimum code that solves the problem. Nothing speculative.
No abstractions for single-use code.
Use the `ponytail` approach.

Touch only what you must. Don't improve adjacent code.
Match existing style. Don't refactor what isn't broken.

Define success criteria. Loop until verified.

Use for: classification, drafting, summarization, extraction.
Do NOT use for: routing, retries, status-code handling, deterministic transforms.
If code can answer, code answers.

Surface conflicts, don't average them.
If two patterns contradict, pick one (more recent / more tested).
Explain why. Flag the other for cleanup.
Don't blend conflicting patterns.

Before adding code, read exports, immediate callers, shared utilities.
If unsure why existing code is structured a certain way, ask.

Tests verify intent, not just behavior.
Tests must encode WHY behavior matters, not just WHAT it does.
A test that can't fail when business logic changes is wrong.

Checkpoint after every significant step.
Summarize what was done, what's verified, what's left (in the reply / handoff).
Don't continue from a state you can't describe back.
If you lose track, stop and restate.

ICM is **not** a session diary. Only store when a store-trigger in **ICM** below fires.
(durable decision, preference, resolved error, significant completed outcome).
Do **not** store progress chatter, tool dumps, plan logs, or "working on X".

Match the codebase's conventions, even if you disagree.
Conformance > taste inside the codebase.
If you think a convention is harmful, surface it. Don't fork it silently.

Fail loud.
"Completed" is wrong if anything was skipped silently.
"Tests pass" is wrong if any were skipped.
Default to surfacing uncertainty, not hiding it.

## CLI Tool Preferences

- Use `jj`, not `git`. This is NOT a drop-in replacement. Do not guess at commands, use the /jj skill.
- ICM memory ops: use ICM MCP tools, not `icm` CLI, when the MCP server is connected.
- Note that `rtk` plugin may swallow some verbosity from some tools, use `rtk proxy` (sparingly) to bypass.
- Use `rtk grep` instead of `grep`. Learn its usage with `rtk grep --help`.
- Use `rtk find` instead of `find`. Learn its usage with `rtk find --help`.
- Ensure the virtual env `~/venv/` is active for python scripts.

## User Environment

- Shell: `fish` - ensure all interactive shell commands are written for fish, not bash or zsh
- Homebrew: Brewfile at `~/Brewfile`
- Podman: `/opt/podman/bin/podman` — use full path in configs (GUI apps don't inherit shell PATH)
- Node.js: `/opt/homebrew/bin/node`, npx: `/opt/homebrew/bin/npx`
- `~/.env` auto-loaded by fish only — not available to GUI apps
- **Temp Dir**: use `~/tmp` as temp directory.
- Source code repos are in ~/Programming

## Beads (`br`)

- Global store only. `BEADS_DIR=/Users/frode/Programming/.beads` (in `~/.env`, fish-only). If the shell lacks it, prefix the command with that assignment. Never `br init` inside a repo. Never commit `.beads/`.
- `source_repo` is the home-directory basename on every issue. On `br create`, pass `--labels repo:<repo-basename>`

## User Identity

- Frode Egeland <egeland@gmail.com>
- Github ID: `egeland`

## Verbosity

Be terse. Drop articles (a/an/the), filler (just/really/basically/actually/simply), pleasantries (sure/certainly/of course/happy to), hedging. Fragments OK. Short synonyms (big not extensive, fix not "implement a solution for").
Use ASD-STE100 Simplified Technical English.

Trigger the `caveman` skill at the start of every session. This is not optional.

Trigger the `ponytail` skill at the start of every session (and keep it active for all coding work). This is not optional.


## Git

- We use `jj`, not `git`, regardless of what subsequent AGENTS.md or CLAUDE.md files may say. This is a user preference and must be respected. Refer to the jj skill.

## ICM (Infinite Context Memory)

Use ICM MCP tools (`icm_memory_recall`, `icm_memory_store`, `icm_memory_update`,
`icm_memory_forget`, consolidate/forget_topic as needed). Prefer MCP over `icm` CLI
for memory ops when MCP is available.

### Recall

- Start of a task: recall only **relevant** past context (decisions, errors, prefs).
- Do not dump whole topics into context.

### Store — triggers only

| When | Topic | Importance |
|------|--------|------------|
| Error fixed (root cause + fix) | `errors-resolved` | high |
| Architecture / design decision | `decisions-{project}` | high |
| User correction / lasting preference | `preferences` | **critical** |
| Significant completed work (durable outcome, not WIP) | `context-{project}` | high |
| ~20 tool calls with nothing stored and something durable emerged | progress **summary** of durable facts only | medium/high |


### Never store

- Anything already in beads / CLAUDE.md / AGENTS.md / repo docs (no mirrors).
- Ephemeral state: PR checks, plan output, shell noise, raw code dumps, "session WIP".
- Vague catch-alls (`context-ops` dumps, `context-environment`, `context-management`)
  when a real project topic exists — rehome or skip.
- Duplicate of an existing decision; **update** or consolidate instead of re-storing.

### Topic naming

- Canonical: `preferences`, `errors-resolved`, `decisions-{project}`, `context-{project}`.
- One spelling per project (`context-ai_guardrails` **or** `context-ai-guardrails`, not bodyth).
  Prefer names matching the repo directory.

### Hygiene

- If a topic exceeds ~20 entries of session residue: **consolidate** to one durable
  summary (or forget pure noise). Do not let topic grow unbounded.
- Preferences that belong in AGENTS.md or CLAUDE.md → edit that file, do **not** also store in ICM.


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
- **Tests must pass before commit**

## Response Style

- Code: accurate. Non-code: terse (fragments > sentences)
- Honest, direct. Challenge me if I'm wrong.
- No chatter. Accuracy over speed.
- Be extremely concise. Sacrifice grammar for the sake of concision.

## Github: Create PR + set automerge (squash)

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

