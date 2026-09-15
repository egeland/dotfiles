---
name: custom-track-link-domain
description: >
  Set up a customer track-link custom domain on an ENGSD ticket (CNAME host +
  account ID). Use when enabling a custom domain / tracked-link TLD / track-link
  CNAME for a customer, or when the user runs /custom-track-link-domain.
  Not for company opt-out domains (unsub.at / custom_opt_out_domain).
---

# Custom track-link domain (ENGSD)

Do this on the ENGSD ticket. Do not open a Kaiju ticket.

Authoritative runbook: https://kudosity.atlassian.net/wiki/spaces/KJU/pages/4535091232/Runbook+-+Custom+Domain+Track+link+Setup (page 4535091232). This skill is the jj-native agent procedure for that runbook.

Repo: `~/git_repos/burst`. File: `ops/infrastructure/environment/production/terraform.tfvars`. Add the host to **both** `track_link_ingresses` and `track_link_httproutes`. One host can serve many accounts; TLD is per-account.

This is **not** opt-out (`custom_opt_out_domain` / `unsub.at`). Wrong module.

## Extract

From the ticket (and comments): **account ID** + **host** (CNAME). Stop if either is missing.

## Git (jj)

Use `jj`, never `git`. Do not use `/start-ticket` or `/pr` (those are git).

1. `jj status`. If WC dirty with unrelated files, STOP and ask. Do not mix this change with other work.
2. `jj git fetch` then `jj new develop`.
3. Bookmark after describe: `ENGSD-NNNN-<host-slug>` (host dots → hyphens, 2–4 words). Example: `ENGSD-1675-shop-thegroomi-com`.

## Skip TF when host already listed

If the host is already in **both** lists: add the new account ID as a comment on the existing entry, skip steps 1–4 of the runbook, go to Forest Admin.

## 1. tfvars

Append the same block to both lists. Comment = company (from ticket/domain) + account ID. No ticket IDs in comments.

```hcl
    # The Groomi, account ID: 172139
    {
      name     = "shop-thegroomi-com"
      dnsNames = ["shop.thegroomi.com"]
    },
```

`name` = host with `.` → `-`. Copy the last existing entry's punctuation.

Several pending ENGSD track-link tickets → one change, all hosts.

## 2. Validate DNS

```bash
cd ops/infrastructure/environment
./validate-track-link.sh production
```

Expected CNAME: `track-link.transmitsms.com`.

Cloudflare-proxied hosts often have A records, not a CNAME. Script yellow-passes if the name resolves — OK when already live. Missing CNAME is not a hard fail in that case. Real NXDOMAIN / no IPs → ping the reporter, do not apply.

## 3. PR (jj)

Ask first: **describe + auto-bookmark push + PR** (default) vs `jj commit`.

Default path:

```bash
jj describe -m "ENGSD-NNNN Add <host> track-link custom domain"
jj git push --named ENGSD-NNNN-host-slug=@
gh pr create --repo burstsms/burst --base develop --head ENGSD-NNNN-host-slug --draft --title "ENGSD-NNNN Add <host> track-link custom domain" --body "..."
open -a "Brave Browser" "<pr-url>"
```

Title: `ENGSD-NNNN Add <host> track-link custom domain` — space after ticket, no colon.

PR body (short):

```markdown
## What we've changed

- Add `<host>` to production `track_link_ingresses` and `track_link_httproutes` for account `<id>`

## Why we've done it

- [ENGSD-NNNN](https://kudosity.atlassian.net/browse/ENGSD-NNNN) — customer custom track-link domain

## Expected behavior

- After apply, `https://<host>/resolve` serves the track-link landing page with a ZeroSSL (or Cloudflare-fronted) cert

## How to test

1. `./validate-track-link.sh production`
2. After merge + apply: open `https://<host>/resolve` in a browser
3. Forest Admin account `<id>` Tracked Link TLD = `<host>`

## Deploy notes

- Self-contained. After merge: `make track-link-apply-production` (explicit approval). Then Forest Admin TLD.
```

`gh` always needs `--repo burstsms/burst`. Draft until user says ready.

## 4. Apply (after merge)

**Never apply without explicit user approval.** Plan first:

```bash
cd ops/infrastructure/environment
make track-link-plan-production
```

Redirect plan to `~/tmp/…`, grep `^Plan:|^Error:|will be (created|destroyed|updated|replaced)`. Show summary in chat (counts + what changes). No local temp paths in the PR.

On approval: `make track-link-apply-production`. Login (`make login` / `aws-sso login`) if AWS creds expired.

## 5. Forest Admin

https://app.forestadmin.com/Kudosity/Production/Engineering/data/transmitsms_user/index/record/transmitsms_user/{accountId}/details

Set **Tracked Link TLD** to the host. Save error on "Date balance alert" → any past date, save again.

No FA API from this skill — open the record URL (Brave) and edit, or tell the user the URL + field.

## 6. Browser check

Open `https://<host>/resolve` in Brave. Expect the track-link landing page.

`curl` may get a Cloudflare challenge. CF/GTS cert (not ZeroSSL) is expected when Cloudflare is in front — do not reissue for that alone.

After apply, public issuer is often `CN=cert-manager.local` (temporary). ACME HTTP-01 may 404 for ~1 min, then Order sits `ready` until ZeroSSL finalize. Wait. Do not wipe Certificate/Order unless still local after ~10 min. `curl -k` 200 on `/resolve` is not TLS done — need issuer `C=AT, O=ZeroSSL GmbH`. Broken HTTPS after that wait → Confluence troubleshooting.

## 7. JSM

Transition **Pending Customer** (status becomes Awaiting Customer Feedback). Do not put a customer-visible comment on the transition itself; post a **public** comment after:

```
Custom track-link domain is ready for testing.

- Host: `<host>` (account <id>)
- Landing page: https://<host>/resolve
- TLS issued by ZeroSSL

Please have the customer send a tracked SMS and confirm the link works.
```

`jira_add_comment` with `public: true`. Internal notes use `public: false`.

## After

If the job actually finished, one `context-burst` / high store: ticket + host + account + FA TLD + JSM status. Update the existing custom-domain memory; do not re-store the runbook (this skill owns it). Hosts already in `terraform.tfvars` are not ICM facts.
