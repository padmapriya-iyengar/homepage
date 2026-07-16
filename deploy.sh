#!/usr/bin/env bash
set -Eeuo pipefail

REPO_DIR="${HOME}/homepage"
WEB_ROOT="/var/www/homepage"
DOMAIN="joshikiran.com"

echo "Updating homepage repository..."
cd "${REPO_DIR}"
git pull --ff-only

echo "Deploying static homepage..."
sudo mkdir -p "${WEB_ROOT}"
sudo install -o www-data -g www-data -m 0644 index.html "${WEB_ROOT}/index.html"
sudo install -o www-data -g www-data -m 0644 styles.css "${WEB_ROOT}/styles.css"
sudo install -o www-data -g www-data -m 0644 script.js "${WEB_ROOT}/script.js"

echo "Validating and reloading Nginx..."
sudo nginx -t
sudo systemctl reload nginx

echo "Checking homepage..."
curl --fail --silent --show-error \
  --header "Host: ${DOMAIN}" \
  "http://127.0.0.1/" > /dev/null

echo "Homepage deployment completed successfully!"
