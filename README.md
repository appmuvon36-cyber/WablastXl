# WablastXl

WablastXl is the self-managed OpenWA source distribution for the WhatsApp Gateway. It imports the upstream application source into this repository and retains WablastXl-specific deployment configuration.

## Source and updates

- Upstream source: https://github.com/rmyndharis/OpenWA
- Upstream license: MIT; the original LICENSE and copyright notices are retained.
- The workflow at .github/workflows/sync-openwa-source.yml imports the upstream main branch into this repository.
- The full backend, dashboard, tests, Dockerfile, API specification, SDKs, and documentation are now tracked here.
- To sync upstream again, run the workflow manually from GitHub Actions or update the sync workflow file to trigger it.
- The upstream .env.example is kept intact. WablastXl deployment defaults are documented separately in .env.wablastxl.example.

## Architecture

- API and dashboard: NestJS backend plus React dashboard served by the same OpenWA process.
- Port: 2785.
- Health endpoint: /api/health/ready.
- Database: SQLite for initial local/volume-backed use; PostgreSQL is supported by upstream.
- WhatsApp engines: whatsapp-web.js and Baileys (capabilities differ; check upstream engine capability matrix).
- Plugin system: sandboxed OpenWA-plugins integration fabric.

## Railway deployment — intentionally postponed

Do not provision or deploy Railway yet. When deployment is approved:
1. Build from this repository's root Dockerfile.
2. Mount persistent storage at /app/data.
3. Expose port 2785.
4. Set health check to /api/health/ready.
5. Configure runtime variables using .env.wablastxl.example and the upstream .env.example reference.
6. Retrieve the initial admin API key securely from first-boot logs and create a WhatsApp session.
7. Scan the QR code with a dedicated WhatsApp number and verify inbound/outbound messages.

The /app/data volume holds database, session/authentication material, media, plugins, and generated API key. Production must not run without persistent storage. Keep one instance per session-data volume; do not share SQLite/session storage across replicas.

## Security and WhatsApp policy

OpenWA uses an unofficial WhatsApp Web-based integration, not the official Meta WhatsApp Cloud API. Account restriction risk exists. Use a dedicated number, obtain recipient opt-in, honor opt-outs, and evaluate the official Cloud API for high-volume commercial messaging. Do not use bulk messaging for unsolicited spam.

## References

- OpenWA: https://github.com/rmyndharis/OpenWA
- OpenWA plugins: https://github.com/rmyndharis/OpenWA-plugins
- Railway OpenWA template: https://railway.com/deploy/openwa-w-postgres-redis-and-minio


## WablastXl operating guides

- [AI Customer Agent architecture and plugin selection](docs/wablastxl/AI-CUSTOMER-AGENT.md)
- [Broadcast consent, suppression, and campaign controls](docs/wablastxl/BROADCAST-COMPLIANCE.md)
- [Operations and QA gates](docs/wablastxl/OPERATIONS-AND-QA.md)
- [Bahasa Indonesia AI system-prompt baseline](docs/wablastxl/AI-SYSTEM-PROMPT-ID.md)

Railway remains intentionally postponed until source CI, integration configuration, and the operational QA gates are complete.
