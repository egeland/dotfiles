---
name: jj
description: >
  Use jj, not git, for status, describe, bookmark, push, and PRs. Triggers: "describe + auto-bookmark + PR",
  "describe + auto-bookmark and push and draft PR", "describe + auto-bookmark + non-draft PR",
  "1 — describe, bookmark, but non-draft PR", "1, but non-draft pr", jj status, jj describe,
  jj git push, Path 1, Path 2, draft PR. Do not run jj --help or jj <cmd> --help for these cases.
user-invocable: true
---

# jj

Load this skill for any version-control work. Do not run `jj --help` or `jj <cmd> --help` for the cases below.

Opening a PR is Path 1. It is not a draft unless the user says draft.
Auto-bookmark is `jj git push --change @`, never `--named`.

jj owns status, describe, push, and commit.

## Ticket

Do not search for a ticket. Use only a ticket already named in this chat or already written on the change.

- One named ticket: suggest it and wait.
- Several named tickets: suggest the one this session is executing. Name the others in the same question.
- No named ticket: ask for the number.

Do not describe, push, or open the PR until the user confirms the ticket.

## Main branch before push

Ignore `@git`. It is the colocated git ref, not the GitHub remote.

`@` is a direct child when it has one parent and that parent is the repository main branch. If it is not a direct child, stop. Do not update `@`. Do not push.

If it is a direct child, fetch and count commits on `<main>@origin` that `@` does not have.

- 0: push.
- 1 to 5: `jj rebase -r @ --onto <main>@origin`, then push. Do not ask.
- More than 5: stop. Show the number. Do not push until the user says to update.

## 1. Dirty gate

Run `jj status` at start. If the working copy has unrelated dirty files, STOP and ask. Ignore bookmark-conflict on leftover `push-*`.

## 2. Inspect

```
jj log -r '@ | @-' --no-graph -T 'change_id.short() ++ " " ++ commit_id.short() ++ " " ++ bookmarks ++ " " ++ description.first_line() ++ "\n"'
jj diff --stat
jj diff
jj bookmark list
```

## 3. Fresh working copy

`jj git fetch` then `jj new main`. If `@` is already empty on the default bookmark, do not `jj new` (empty parent). Extra empty parent: `jj rebase -r @ --onto develop` then `jj abandon <id>`. After a merge: `jj git fetch && jj new <default>`.

## 4. Stay on `@`

Edit files. Do not `jj commit` or `jj new`.

## 5. Describe

`jj describe -m "<ticket id> …"` — space after the ticket, no colon.

## 6. Path 1 auto-bookmark (default)

Confirm the ticket and run the main-branch check first.

1. `jj describe -m "<ticket id> …"`
2. `jj git push --change @` (bookmark `push-<change_id.short()>`)
3. `gh pr create --repo OWNER/REPO --base <develop|main> --head <bookmark> [--draft]`
4. Open Brave with the `gh pr create` URL as a quoted literal: `open -a "Brave Browser" "https://github.com/OWNER/REPO/pull/N"`. Run `open` only when the argument starts with `https://`. An empty argument opens the current directory as `file://`. Do not use `$(gh pr view ...)`. A lookup needs the number first: `gh pr view N --repo OWNER/REPO --json url -q .url`.

Never `jj commit`. Never `--named` for auto-bookmark.

## 7. Named bookmark

1. `jj describe -m "KJU-NNNN …"`
2. `jj git push --named TICKET-descriptive-suffix=@`
3. Same `gh pr create` + Brave as Path 1.

## 8. Draft vs ready

Pass `--draft` when asked.

## 9. Path 2 (`jj commit`)

Only if the user says `jj commit`. `jj commit -m "…"` is describe+new (`@` empty). Push the parent: `jj git push --named NAME=@-`. Do not re-ask Path 1 vs 2. `"jj commit, but don't push"`: commit only.

## 10. Later push of that change

If the change moved onto `@`, Path 1 `jj git push --change @`.

## 11. Update an open PR (same turn; do not wait for "did you push")

Named: `jj describe` then `jj git push --bookmark <name>` **or** `jj bookmark move BOOKMARK --to @ && jj git push -b BOOKMARK`. Auto: another `jj git push --change @` (bookmark moves sideways). Do not rebase an open PR unless asked. The main-branch check above is the only rebase that runs without a question.
Ask if the user wants the PR opened in Brave browser again (it may already be open).

## 12. Untrack

Add to gitignore first, then `jj file untrack PATH`.

## 13. Rollback uncommitted follow-up

`jj abandon`. Bookmark and PR stay.

## 14. Init colocated

`jj git init` only if `jj status` says there is no jj repo.
We prefer to NOT have colocated repos.

## 15. Remotes

`jj git remote` has no `-l`. Use `jj git remote list`.

## 16. gh

Always `gh pr create --repo OWNER/REPO`.
`gh api` path `/repos/OWNER/REPO/...` (`--repo` is not a flag on `gh api`). `gh pr edit N --repo OWNER/REPO`. Then Brave, using the quoted `https://` URL from step 6.4. An empty `open` argument opens the current directory as `file://` and must be avoided.

## 17. Never git

Never `git status`, `git add`, `git commit`, `git push -u`, `git checkout -b`. `git fetch` / `git show` as fallback only.
If the current repo is not managed in `jj`, ask the user whether it should be initialised as per step 14.
