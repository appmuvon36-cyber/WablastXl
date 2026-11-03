# WablastXl

WablastXl is the self-managed OpenWA source deployment for the WhatsApp Gateway. This repository is configured to import the upstream OpenWA source into this repository while retaining the WablastXl Railway deployment profile.

## Source and updates

- Upstream source: https://github.com/rmyndharis/OpenWA
- Upstream license: MIT; preserve the upstream LICENSE and copyright notices.
- The workflow at .github/workflows/sync-openwa-source.yml imports the upstream main branch into this repository.
- After the initial import, the complete OpenWA application source, tests, dashboard, Dockerfile, and documentation are stored in this repository.
- To sync upstream again, run the workflow manually from GitHub Actions.

## Railway deployment

1. Create a Railway project and add a service from GitHub: appmuvon36-cyber/WablastXl.
2. Use the repository root and Dockerfile builder. The imported upstream Dockerfile builds the source in this repository.
3. Add a Railway Volume mounted exactly at /app/data.
4. Set public networking target port to 2785.
5. Configure the variables in .env.example in Railway's Variables panel.
6. Deploy and wait for /api/health/ready to pass.
7. Generate a Railway HTTPS domain.
8. Open the dashboard, retrieve the initial admin API key from deployment logs, create a WhatsApp session, and scan its QR code.

## Runtime and persistence

The /app/data volume stores SQLite data, WhatsApp session/authentication material, media, plugins, and the generated admin API key. Production must not run without this volume. Use one replica per persistent data volume; do not share the SQLite/session volume across replicas.

OpenWA generates the initial admin API key on first boot, prints it once in deployment logs, and stores it at /app/data/.api-key. Store it securely. Never commit credentials or expose admin keys in browser code.

## WablastXl deployment defaults

- Port: 2785
- Health check: /api/health/ready
- Timezone: Asia/Jakarta
- Database: SQLite on persistent volume for initial deployment
- Engine: whatsapp-web.js
- Auto-start authenticated sessions: enabled

## Security and WhatsApp policy

OpenWA uses an unofficial WhatsApp Web-based integration, not the official Meta WhatsApp Cloud API. Account restriction risk exists. Use a dedicated number, obtain recipient opt-in, honor opt-outs, and evaluate the official Cloud API for high-volume commercial messaging.

## References

- OpenWA: https://github.com/rmyndharis/OpenWA
- OpenWA plugins: https://github.com/rmyndharis/OpenWA-plugins
- Railway OpenWA template: https://railway.com/deploy/openwa-w-postgres-redis-and-minio
