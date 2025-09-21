#!/usr/bin/env bash
set -e

# --- Parse args ---
ROLE=""
TAG="@SmokeTest"   # default tag

for arg in "$@"; do
  case $arg in
    -role=*|--role=*)
      ROLE="${arg#*=}"
      ;;
    -tags=*|--tags=*)
      TAG="${arg#*=}"
      ;;
  esac
done

# --- Require ROLE ---
if [ -z "$ROLE" ]; then
  echo "❌ ERROR: ROLE is mandatory"
  echo "👉 Usage: ./run_test.sh -role=admin [-tags=@SmokeTest]"
  exit 1
fi

echo "🔑 Running tests with ROLE=$ROLE TAG=$TAG"

# --- Load variables from .env ---
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "❌ .env file not found!"
  exit 1
fi

# --- Prepare certs ---
mkdir -p certs
P12_FILE="certs/${ROLE}.p12"
CERT_FILE="certs/${ROLE}_cert.pem"
KEY_FILE="certs/${ROLE}_key.pem"

if [ ! -f "$P12_FILE" ]; then
  echo "❌ Expected file $P12_FILE not found!"
  exit 1
fi

if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
  echo "📜 Converting $P12_FILE into PEM cert and key..."
  openssl pkcs12 -in "$P12_FILE" -clcerts -nokeys -out "$CERT_FILE" -passin pass:"$P12_PASSWORD"
  openssl pkcs12 -in "$P12_FILE" -nocerts -nodes -out "$KEY_FILE" -passin pass:"$P12_PASSWORD"
  echo "✅ Generated $CERT_FILE and $KEY_FILE"
else
  echo "ℹ️ Using existing PEM cert and key for ROLE=$ROLE"
fi

# --- Export for Playwright ---
export ROLE
export CERT_PATH="$CERT_FILE"
export CERT_KEY="$KEY_FILE"
export CERT_URL="$CERT_URL"

# --- Run Cucumber with Playwright ES Module integration ---
# npx cucumber-js tests/features \
#   --import tests/steps/**/*.ts \
#   --import tests/support/**/*.ts \
#   --format json:reports/cucumber.json \
#   --tags "$TAG"

npx cucumber-js tests/features \
  --require-module ts-node/register \
  --require-module tsconfig-paths/register \
  --require tests/steps/**/*.ts \
  --require tests/support/**/*.ts \
  --format json:reports/cucumber.json \
  --tags "$TAG"

# --- Run Cucumber via config ---
#npx cucumber-js --config cucumber.config.mjs

