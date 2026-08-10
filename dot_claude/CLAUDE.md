# Global guidance

## Coding rules

### Rule 1 — Think Before Coding

State assumptions explicitly. Ask rather than guess.
Push back when a simpler approach exists. Stop when confused.

### Rule 2 — Simplicity First

Minimum code that solves the problem. Nothing speculative.
No abstractions for single-use code.
Use the `ponytail` approach.

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
Update icm mcp at each checkpoint.
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

- Use `jj`, not `git`. This is NOT a drop-in replacement. Do not guess at commands, check `jj --help` if unsure.
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
- **Never HTML-escape comparison operators in Jira bodies.** Write plain `<` / `>` or rephrase as "below" / "above" / "at or above". Using `&lt;` / `&gt;` (or other HTML entities) renders literally as `&gt;` in the ticket UI — the MCP/wiki path does not decode them. Same for `&amp;`, `&nbsp;`, etc.: use the real character or words.
- Never create issues of the type sub-task unless explicitly instructed to.

## Repository Conventions

- GitHub organisation: `burstsms`
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

- We use `jj`, not `git`, regardless of what subsequent CLAUDE.md files may say. This is a user preference and must be respected.
- If `jj status` is not clean when you are starting work, STOP and ask the user for guidance. This is not optional.
- `jj` bookmarks (analogous to git branches) should include a descriptive suffix, not just the ticket number
- **PR workflow (default): describe + auto-bookmark — not `jj commit`.**
  - In jj there is no staging area; work lives on the working-copy change `@`. A PR is made by **describing** `@` and **pushing** it, not by `jj commit` (which is `describe` + `new` and leaves `@` empty).
  - **Before** finalising a PR (or when the user asks to “commit” / “ship” / “PR”), **ask** which they want:
    1. **Describe + auto-bookmark push + PR** (default / preferred) — keep the change as `@`, push it, open PR.
    2. **`jj commit`** (`describe` + `new`) — only if they explicitly want the change finalised off `@`.
  - Do not assume either path. If they already said “auto-bookmark” / “describe then push”, skip the ask and use path 1.
  - Path 1 steps:
    1. `jj describe -m "KJU-NNNN …"` (ticket + short summary; multi-line body OK)
    2. Auto-bookmark push: `jj git push --change @` — creates a tracked bookmark from the change ID and pushes it.
       - Default name template: `templates.git_push_bookmark` = `"push-" ++ change_id.short()` → e.g. `push-tlrxvlnzrzoz` / `push-tssmzzkslmos`.
       - Descriptive name instead: `jj git push --named KJU-2597-descriptive-suffix=@`
    3. Draft PR: `gh pr create --repo OWNER/REPO --base <default> --head <bookmark> --draft ...`
    4. **Always open the PR in Brave** (draft or ready): `open -a "Brave Browser" <pr-url>` — do this after every `gh pr create` / `gh pr view --web` equivalent. Never leave the user to hunt the link.
- Github PR titles must start with the ticket number then a space — `KJU-2390 Text here`, NOT `KJU-2390: Text here` (no colon)
- `gh` CLI does not work in pure `jj` repos (no `.git` dir). Always pass `--repo OWNER/REPO` explicitly. Example: `gh pr create --repo burstsms/burst --base develop --head <bookmark> ...`

## Terraform/Terragrunt/Tofu Plan Workflow

When running `terraform plan`, `terragrunt plan` or `tofu plan` and needing to inspect output in multiple ways: **run once, redirect to a temp file, then grep the file**. Never run plan multiple times for the same inspection. The same rule applies for `apply` and `destroy`.
Use `| grep -E "^Plan:|^Error:|will be (created|destroyed|updated|replaced)|error occurred|failed to"` at the end of the `tee` to detect any conditions that we need to know about. Examine the file if that grep gives no output.
Always run `tofu fmt` before making any git commits when Terraform files have been edited (`.tf`, `.tfvars`, etc.). **Formatting failures block CI** — when `tofu fmt -diff` shows output, the changes have been applied in-place; always include those files in the subsequent push. Never leave unformatted files in a pushed commit.

IMPORTANT: Never run `terraform apply`, `terragrunt apply`, or `tofu apply` without EXPLICIT approval from the user. Get approval for each instance of apply.

## People / Org Chart

- Kudosity org chart is stored in ICM under topic `people-kudosity`
- When a person's name comes up, recall from ICM before asking or guessing: `icm recall "<name>" -t people-kudosity`
- Covers: roles, teams, reporting lines, active/former status for ~50 Kudosity staff

@RTK.md
