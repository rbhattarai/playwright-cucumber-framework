#!/bin/bash
set -euo pipefail

ROLE=${1:-admin}
TAG=${2:-"@SmokeTest"}

# Convert .p12 to PEM cert + key
CERT_FILE="certs/cn=rohan_bhattarai_proj_${ROLE}.p12"
PASSWORD="changeit"

openssl pkcs12 -in "$CERT_FILE" -clcerts -nokeys -out certs/client-cert.pem -passin pass:$PASSWORD -legacy
openssl pkcs12 -in "$CERT_FILE" -nocerts -nodes -out certs/client-key.pem -passin pass:$PASSWORD -legacy

echo "🔐 Certificate extracted. Launching tests for role=$ROLE with tag=$TAG..."

export CERT_PATH=certs/client-cert.pem
export CERT_KEY=certs/client-key.pem
export CERT_URL=https://your-app-url.com

echo "Running tests with cert for role=$ROLE"

#npx cucumber-js --require-module ts-node/register --require step-definitions/**/*.ts features/**/*.feature --tags "$TAG"
npm run e2e
