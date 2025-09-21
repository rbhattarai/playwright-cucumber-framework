
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


## Setup for TypeScript Path Aliases (CommonJS)

1. Ensure your `package.json` does **not** have `"type": "module"` (or remove it if present).
2. Install `tsconfig-paths`:
    ```sh
    npm install tsconfig-paths
    ```
3. Use path aliases in your `tsconfig.json` as needed (already set up in this repo).
4. Update your test scripts to include both `ts-node/register` and `tsconfig-paths/register`:
    ```json
    "e2e": "npx cucumber-js --require-module ts-node/register --require-module tsconfig-paths/register --require tests/steps/**/*.ts --require tests/support/**/*.ts --format json:reports/cucumber.json --tags '@SmokeTest'"
    ```
5. In your shell script (`run_test.sh`), use `--require` (not `--import`) and include both modules:
    ```sh
    npx cucumber-js tests/features \
      --require-module ts-node/register \
      --require-module tsconfig-paths/register \
      --require tests/steps/**/*.ts \
      --require tests/support/**/*.ts \
      --format json:reports/cucumber.json \
      --tags "$TAG"
    ```

## Running Tests

You can run tests using either:

```sh
npm run e2e
# or
./run_test.sh -role=admin
```

## Notes

- Path aliases (like `@support/world`) now work in your TypeScript step definitions and support files.
- Do **not** use `--import` or ESM mode if you want path alias support at runtime.
- If you see module resolution errors, double-check that you are using `--require` and have removed `"type": "module"` from `package.json`.

## About `run_test.sh`

The `run_test.sh` script is a wrapper for running your Playwright+Cucumber tests with additional environment and certificate management. It provides:

- **Argument parsing**: Requires a `-role=ROLE` argument (e.g., `-role=admin`). Optionally accepts `-tags=TAG` (default: `@SmokeTest`).
- **Environment loading**: Loads variables from a `.env` file (must exist in the project root).
- **Certificate preparation**:
    - Checks for the existence of the required `.p12` certificate for the given role in the `certs/` directory.
    - If needed, converts the `.p12` file to PEM certificate and key files using OpenSSL and the password from the environment.
    - Sets environment variables (`ROLE`, `CERT_PATH`, `CERT_KEY`, `CERT_URL`) for use in your tests.
- **Test execution**: Runs Cucumber tests with the correct modules and arguments for TypeScript and path alias support.

### Usage

```sh
./run_test.sh -role=admin [-tags=@SmokeTest]
```

### Example

```sh
./run_test.sh -role=admin -tags='@LoginTest'
```

### What it does

1. Verifies the required role and tag arguments.
2. Loads environment variables from `.env`.
3. Prepares certificates for the specified role (converts `.p12` to `.pem` and `.key` if needed).
4. Exports cert and role variables for Playwright.
5. Runs Cucumber tests with all required modules and arguments for TypeScript and path alias support.

If any required file or environment variable is missing, the script will exit with an error and a helpful message.
