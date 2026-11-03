# WablastXl

Railway-ready deployment profile powered by [OpenWA](https://github.com/rmyndharis/OpenWA).

## Current source model

This repository contains WablastXl deployment configuration. The OpenWA application runtime is consumed from its official multi-architecture GHCR image: `ghcr.io/rmyndharis/openwa:latest`. **This is a deployment wrapper, not a complete source-code fork.** A full fork requires GitHub's Fork action on the upstream repository, then moving this deployment profile into that fork. Upstream MIT notices must be preserved.

## Railway deployment

1. Create a Railway project and add a service from GitHub: `appmuvon36-cyber/WablastXl`.
2. Let Railway build using the root `Dockerfile`.
3. Add a Railway Volume mounted exactly at `/app/data`.
4. Set public networking target port to `2785`.
5. Configure the variables in `.env.example` in Railway's Variables panel.
6. Deploy and wait for `/api/health/ready` to pass.
7. Generate a Railway HTTPS domain.
8. Open the dashboard, use the initial admin API key from deployment logs, create a WhatsApp session, and scan its QR code.

## Persistence and security

The `/app/data` volume stores SQLite data, WhatsApp session/authentication material, media, plugins, and the generated admin API key. Do not run production without it. Keep one replica per data volume; do not share the SQLite/session volume across replicas.

The initial admin API key is generated on first boot, printed once in deployment logs, and stored at `/app/data/.api-key`. Store it securely. Never commit credentials or expose admin keys in browser code.

OpenWA uses an unofficial WhatsApp Web-based integration, not the official Meta WhatsApp Cloud API. Account restriction risk exists. Use a dedicated number, obtain recipient opt-in, honor opt-outs, and evaluate the official Cloud API for large-scale commercial messaging.

## Runtime

- Container: official OpenWA GHCR image
- Port: 2785
- Health: `/api/health/ready`
- Database: SQLite on persistent volume
- Engine: whatsapp-web.js
- Timezone: Asia/Jakarta

## References

- [OpenWA source](https://github.com/rmyndharis/OpenWA)
- [OpenWA plugins](https://github.com/rmyndharis/OpenWA-plugins)
- [Railway OpenWA template](https://railway.com/deploy/openwa-w-postgres-redis-and-minio)
