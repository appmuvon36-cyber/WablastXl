# WablastXl deployment image
# Runtime and browser security patches are maintained in the official OpenWA image.
FROM ghcr.io/rmyndharis/openwa:latest

ENV NODE_ENV=production \
    PORT=2785 \
    TZ=Asia/Jakarta \
    AUTO_START_SESSIONS=true \
    DATABASE_TYPE=sqlite \
    DATABASE_NAME=./data/openwa.sqlite \
    DATABASE_SYNCHRONIZE=false \
    ENGINE_TYPE=whatsapp-web.js \
    SESSION_DATA_PATH=./data/sessions \
    PUPPETEER_HEADLESS=true \
    PUPPETEER_ARGS=--no-sandbox,--disable-setuid-sandbox,--disable-dev-shm-usage,--disable-gpu \
    STORAGE_TYPE=local \
    STORAGE_LOCAL_PATH=./data/media

EXPOSE 2785
