# WablastXl — Operations and QA Gates

## Current scope

Railway deployment is intentionally postponed. Work in this phase is source preparation, configuration, test automation, and integration design. No WhatsApp number is logged in and no outbound campaign is authorized yet.

## Source repository

- Repository: https://github.com/appmuvon36-cyber/WablastXl
- Upstream: https://github.com/rmyndharis/OpenWA
- Current imported upstream revision: `11bb9592fcb0d40377159dd6012527000136c6e4`
- Source version: `0.27.1`
- Upstream MIT license retained in `LICENSE`.
- Source sync workflow: `.github/workflows/sync-openwa-source.yml`.
- CI workflow: `.github/workflows/ci.yml`.

## Pre-deployment gates

### A. Repository integrity
- [x] Full upstream source imported.
- [x] Backend, dashboard, Dockerfile, lockfiles, tests, SDKs, OpenAPI, and documentation present.
- [x] Upstream MIT license retained.
- [x] WablastXl README and Railway runtime profile preserved separately.
- [x] Source sync workflow excludes the workflow directory to avoid GitHub App workflow-permission escalation.
- [ ] Run all CI lanes and resolve every failure.
- [ ] Review Dependabot-generated dependency update PRs; do not auto-merge without CI/security review.
- [ ] Pin a reviewed upstream release/tag or commit for production; avoid an unreviewed floating source revision.

### B. Application quality
- [ ] Root lint and full TypeScript typecheck.
- [ ] OpenAPI snapshot and SDK contract checks.
- [ ] Root unit, docs, script, and e2e tests.
- [ ] Dashboard lint, typecheck, i18n parity, unit tests, and production build.
- [ ] Production Docker build and non-root runtime smoke.
- [ ] Review dependency audit findings and resolve/approve each one.

### C. WhatsApp session
- [ ] Create a dedicated business number.
- [ ] Connect QR session only after the runtime is deployed with persistent storage.
- [ ] Verify reconnect after restart and persistence of authentication.
- [ ] Verify inbound text, media caption, and outbound reply.
- [ ] Verify session disconnect, retry, and failure states.

### D. AI and human support
- [ ] Publish and test the Typebot flow.
- [ ] Install and configure Typebot connector.
- [ ] Install FAQ/menu/after-hours plugins only after their response order is reviewed.
- [ ] Configure Chatwoot API inbox and signed account-level webhook.
- [ ] Verify two-way message relay and media.
- [ ] Assign a human agent and verify bot silence for that chat.
- [ ] Unassign the human and verify bot automation resumes.
- [ ] Test prompt injection, unknown answers, provider timeout, duplicate delivery, and opt-out phrases.

### E. Broadcast
- [ ] Consent source and proof available for every recipient.
- [ ] Durable opt-out/suppression list available.
- [ ] Approval roles and immutable campaign message version defined.
- [ ] Idempotency, pacing, status reconciliation, retry, and cancel verified.
- [ ] Test only with explicitly opted-in internal test numbers.
- [ ] Obtain approval before the first real campaign.

## CI interpretation

A green GitHub Actions run verifies only the jobs included in that run. It does not prove WhatsApp connectivity, QR login, Chatwoot/Typebot credentials, or real message delivery. Record these as separate operational checks.

## Rollback

- Keep the last known-good source commit and container image tag.
- Back up the persistent `/app/data` volume before upgrades.
- Do not downgrade Chromium across a live WhatsApp session without following the upstream migration/backup guidance.
- Stop campaigns first, then stop or roll back the gateway if a session or account restriction signal appears.
