# playwright-cucumber-framework


## Step 1: Extract .pem and .key from .p12
Please run this manually in a terminal:

- Change path and password accordingly
CERT_P12="certs/cn=rohan_bhattarai_proj_admin.p12"
PASSWORD="changeit"

- Extract certificate
openssl pkcs12 -in "$CERT_P12" -clcerts -nokeys -out certs/client-cert.pem -passin pass:$PASSWORD -legacy

- Extract private key
openssl pkcs12 -in "$CERT_P12" -nocerts -nodes -out certs/client-key.pem -passin pass:$PASSWORD -legacy


You will get:

certs/client-cert.pem
certs/client-key.pem

## Directory structure:

playwright-cucumber-framework/
// ├── certs/
// │   ├── client-cert.pem
// │   └── client-key.pem
// ├── features/
// │   └── login.feature
// ├── step-definitions/
// │   └── login.steps.ts
// ├── tests/
// │   └── login.test.ts
// ├── .env
// ├── cucumber.js
// ├── package.json
// ├── playwright.config.ts
// └── run_test.sh


## In package.json

    "e2e": "npx cucumber-js --require-module ts-node/register",
    OR
    "e2e": "cucumber-js --require cucumber.conf.ts --require tests/steps/**/*.ts --tags '@SmokeTest'",

Run test:

npm run e2e
OR
./run_test.sh 

