# WablastXl — Broadcast and Campaign Controls

## Purpose

Broadcast is a campaign tool for legitimate, expected communications—not an unsolicited contact scraper or spam tool. The system must enforce consent, suppression, approvals, pacing, idempotency, and auditability before any production campaign is enabled.

## Recipient eligibility

Every recipient must have:
- a normalized WhatsApp destination;
- a recorded opt-in event, timestamp, and source;
- a declared purpose/category for the communication;
- a status that is not opted out, blocked, invalid, or under suppression.

Exclude group chats, broadcast lists, status/newsletter destinations, and unverified numbers from campaign audiences. Never infer consent from a public phone number or an existing contact list.

## Opt-out and suppression

- Recognize clear opt-out phrases in Bahasa Indonesia and common variants (e.g. STOP, BERHENTI, UNSUBSCRIBE).
- Acknowledge the opt-out once, then add the destination to a durable suppression list.
- Check suppression again immediately before sending, not only when the audience is first built.
- Suppression must override campaign membership and manual CSV imports.
- Provide a documented re-consent process; do not silently reactivate an opted-out number.

## Campaign lifecycle

1. Draft: create campaign, message template, sender session, and audience segment.
2. Validate: normalize numbers, deduplicate, check consent, suppress opted-out destinations, and estimate volume/cost.
3. Approve: require an authorized operator to approve the exact message and recipient count.
4. Queue: create immutable recipient jobs with idempotency keys.
5. Send: process at a conservative, configurable pace with randomized delays and a circuit breaker.
6. Reconcile: record accepted, sent, delivered/read when the engine exposes them, failed, skipped, and cancelled states separately.
7. Report: retain operator, campaign, template version, timestamps, counts, and failure reasons.

## OpenWA bulk-send API

The upstream API exposes a batch endpoint:

`POST /api/sessions/:sessionId/messages/send-bulk`

The endpoint accepts asynchronous batches (up to 100 items per request) with configurable per-message delay; supported delay range is 1,000–60,000 ms and randomized delay is available. A successful HTTP acceptance (202) means the batch was queued, **not** that messages were delivered. Poll the batch status endpoint and reconcile final outcomes. The exact API contract shipped with this source is in `openapi.json` and `docs/06-api-specification.md`.

## Required technical controls

- Server-side authorization: only campaign operators may draft; only designated approvers may release.
- Idempotency key per campaign + recipient + message version.
- Durable queue and retry policy; no blind retry of an uncertain send.
- Rate limit per sender session and per destination; global stop switch and campaign cancel.
- Circuit breaker on repeated errors, session disconnect, account restriction signals, or provider throttling.
- Per-recipient opt-out check immediately before send.
- No contact scraping or enrichment without a lawful basis and clear consent.
- Never claim delivery from an HTTP 202 response.
- Keep a complete audit trail without logging message secrets or unnecessary personal data.

## WhatsApp platform risk

OpenWA uses an unofficial WhatsApp Web-based integration and is not the official Meta WhatsApp Cloud API. Sending patterns that look like bulk unsolicited messaging can lead to account restrictions. Use a dedicated business number, conservative volume, explicit opt-in, and an opt-out mechanism. For sustained high-volume commercial messaging, evaluate the official WhatsApp Business Platform / Cloud API and its template and policy requirements.

## Production activation gate

No real broadcast is authorized until consent records, suppression storage, role permissions, approval workflow, test recipients, status reconciliation, and cancellation have all passed QA. Do not send test campaigns to scraped or random phone numbers.
