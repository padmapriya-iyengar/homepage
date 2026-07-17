#!/usr/bin/env bash
set -Eeuo pipefail

REPO_DIR="${HOME}/homepage"
WEB_ROOT="/var/www/html"
DOMAIN="joshikiran.com"

echo "Updating homepage repository..."
cd "${REPO_DIR}"
git pull --ff-only

echo "Deploying static homepage..."
sudo mkdir -p "${WEB_ROOT}"
sudo install -o www-data -g www-data -m 0644 index.html "${WEB_ROOT}/index.html"
sudo install -o www-data -g www-data -m 0644 styles.css "${WEB_ROOT}/styles.css"
sudo install -o www-data -g www-data -m 0644 script.js "${WEB_ROOT}/script.js"
sudo install -o www-data -g www-data -m 0644 manifest.webmanifest "${WEB_ROOT}/manifest.webmanifest"
sudo install -o www-data -g www-data -m 0644 service-worker.js "${WEB_ROOT}/service-worker.js"
sudo install -o www-data -g www-data -m 0644 app-icon.svg "${WEB_ROOT}/app-icon.svg"
sudo install -o www-data -g www-data -m 0644 browserconfig.xml "${WEB_ROOT}/browserconfig.xml"

echo "Validating and reloading Nginx..."
sudo nginx -t
sudo systemctl reload nginx

echo "Checking homepage..."
curl --fail --silent --show-error \
  --resolve "${DOMAIN}:443:127.0.0.1" \
  "https://${DOMAIN}/" > /dev/null

echo "Homepage deployment completed successfully!"
