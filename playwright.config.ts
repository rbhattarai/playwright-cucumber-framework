import { defineConfig } from '@playwright/test';
import * as dotenv from 'dotenv';
import fs from 'fs';
dotenv.config();

const cert = fs.readFileSync(process.env.CERT_PATH!);
const key = fs.readFileSync(process.env.CERT_KEY!);

export default defineConfig({
  use: {
    baseURL: process.env.CERT_URL,
    launchOptions: {
      headless: false,
    },
    contextOptions: {
      httpCredentials: undefined,
      ignoreHTTPSErrors: true,
      extraHTTPHeaders: {},
      proxy: undefined,
      permissions: [],
      viewport: { width: 1280, height: 720 },
      clientCert: {
        cert,
        key,
      },
    },
  },
});

