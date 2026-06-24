# Global guidance

## Coding rules

### Rule 1 — Think Before Coding

State assumptions explicitly. Ask rather than guess.
Push back when a simpler approach exists. Stop when confused.

### Rule 2 — Simplicity First

Minimum code that solves the problem. Nothing speculative.
No abstractions for single-use code.

### Rule 3 — Surgical Changes

Touch only what you must. Don't improve adjacent code.
Match existing style. Don't refactor what isn't broken.

### Rule 4 — Goal-Driven Execution

Define success criteria. Loop until verified.
Strong success criteria let Claude loop independently.

### Rule 5 — Use the model only for judgment calls

Use for: classification, drafting, summarization, extraction.
Do NOT use for: routing, retries, status-code handling, deterministic transforms.
If code can answer, code answers.

### Rule 6 — Token budgets are not advisory

Per-task: 4,000 tokens. Per-session: 30,000 tokens.
If approaching budget, summarize and start fresh.
Surface the breach. Do not silently overrun.

### Rule 7 — Surface conflicts, don't average them

If two patterns contradict, pick one (more recent / more tested).
Explain why. Flag the other for cleanup.
Don't blend conflicting patterns.

### Rule 8 — Read before you write

Before adding code, read exports, immediate callers, shared utilities.
Use gitnexus MCP to get overview of related code.
If unsure why existing code is structured a certain way, ask.

### Rule 9 — Tests verify intent, not just behavior

Tests must encode WHY behavior matters, not just WHAT it does.
A test that can't fail when business logic changes is wrong.

### Rule 10 — Checkpoint after every significant step

Summarize what was done, what's verified, what's left.
Update mempalace mcp and icm mcp at each checkpoint.
Don't continue from a state you can't describe back.
If you lose track, stop and restate.

### Rule 11 — Match the codebase's conventions, even if you disagree

Conformance > taste inside the codebase.
If you think a convention is harmful, surface it. Don't fork it silently.

### Rule 12 — Fail loud

"Completed" is wrong if anything was skipped silently.
"Tests pass" is wrong if any were skipped.
Default to surfacing uncertainty, not hiding it.

## CLI Tool Preferences

- Note that `rtk` plugin may swallow some verbosity from some tools, use `rtk proxy` (sparingly) to bypass.
- Use `rtk grep` instead of `grep`. Learn its usage with `rtk grep --help`.
- Use `rtk find` instead of `find`. Learn its usage with `rtk find --help`.
- Use `tofu` instead of `terraform` unless explicitly agreed. Run `tofu fmt` before committing edited `.tf` files.
- In repos where terragrunt is used, always run `terragrunt hclfmt` before committing edited `.hcl` files.
- Ensure the virtual env `~/venv/` is active for python scripts.
- AWS auth:
  - Run `aws-sso login` to auth to AWS on the user's behalf when needed.
  - Always prepend `aws-sso exec -p <profile>` to every `aws` command you run.
  - Non-prod: `TransmitSMSNon-Prod:AdministratorAccess`.
  - List profiles with `aws-sso list`.

## User Environment

- Shell: fish
- Homebrew: Brewfile at `~/Brewfile`
- Podman: `/opt/podman/bin/podman` — use full path in configs (GUI apps don't inherit shell PATH)
- Node.js: `/opt/homebrew/bin/node`, npx: `/opt/homebrew/bin/npx`
- `~/.env` auto-loaded by fish only — not available to GUI apps
- **Temp Dir**: use `~/tmp` as temp directory.

## User Identity

- Frode Egeland <frode.egeland@kudosity.com>
- Github ID: `egeland`

## Jira

- User is in KJU project.
- Always call `jira_link_to_epic` for each child ticket — `parent` in `additional_fields` does not establish epic links
- When updating Jira via MCP, use markdown numbered lists (`1.`, `2.`, `3.`) — the tool converts to Jira wiki `#` syntax. Using `#` directly causes double-conversion to h1 headers.
- Never create issues of the type sub-task unless explicitly instructed to.

## Repository Conventions

- `burstsms/burst` uses `develop` as its default branch, not `main`. Always target PRs to `develop`.

## Confluence

- User is in KJU space.
- Confluence page URLs follow the format: `https://kudosity.atlassian.net/wiki/spaces/{SPACE_KEY}/pages/{PAGE_ID}/{URL+encoded+title}`
- The MCP tool returns URLs without `/wiki/` prefix — these 404. Always add `/wiki/` when constructing links.
- To mark items as done, always use the ✅ emoji, not `[x]`
- Unless explicitly asked to do it differently, always show the user a draft of changes proposed.

## Claude Code MCP Configuration

- MCP config is `~/.claude.json` → `mcpServers` (the key in `settings.json` is ignored)
- MCP server credentials go in `env` block inside `~/.claude.json` (GUI apps can't read `~/.env`)
- Podman on Apple Silicon: amd64 images too slow for MCP under emulation — use native arm64 tools

## Verbosity

Be terse. Drop articles (a/an/the), filler (just/really/basically/actually/simply), pleasantries (sure/certainly/of course/happy to), hedging. Fragments OK. Short synonyms (big not extensive, fix not "implement a solution for").

Trigger the `caveman` skill at the start of every session. This is not optional.

When asked to create a slack message, remember to wrap single lines of code/config in single backticks, and multi-line in triple backticks.

## Git

- Check if rebase needed before git push or `gh pr`
- Never work on main/develop branch—use worktree/worktrunk instead. Ask the user if we are already on the desired branch/worktrunk, do not assume.
- Prefer `wt switch --create <name>` over `git branch`
- Git branches should include a descriptive suffix, not just the ticket number
- PR titles must start with the ticket number then a space — `KJU-2390 Text here`, NOT `KJU-2390: Text here` (no colon)

## Terraform/Terragrunt/Tofu Plan Workflow

When running `terraform plan`, `terragrunt plan` or `tofu plan` and needing to inspect output in multiple ways: **run once, redirect to a temp file, then grep the file**. Never run plan multiple times for the same inspection. The same rule applies for `apply` and `destroy`.
Use `| grep -E "^Plan:|^Error:|will be (created|destroyed|updated|replaced)|error occurred|failed to"` at the end of the `tee` to detect any conditions that we need to know about. Examine the file if that grep gives no output.
Always run `tofu fmt` before making any git commits when Terraform files have been edited (`.tf`, `.tfvars`, etc.).

IMPORTANT: Never run `terraform apply`, `terragrunt apply`, or `tofu apply` without EXPLICIT approval from the user in that message.

## People / Org Chart

- Kudosity org chart is stored in ICM under topic `people-kudosity`
- When a person's name comes up, recall from ICM before asking or guessing: `icm recall "<name>" -t people-kudosity`
- Covers: roles, teams, reporting lines, active/former status for ~50 Kudosity staff

@RTK.md
