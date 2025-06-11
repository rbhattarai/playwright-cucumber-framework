import { Given, Then } from '@cucumber/cucumber';
import { chromium } from 'playwright';
import * as dotenv from 'dotenv';
dotenv.config();

let page;

Given('I navigate to the login page', async () => {
  const browser = await chromium.launch();
  const context = await browser.newContext({
    clientCert: {
      cert: process.env.CERT_PATH!,
      key: process.env.CERT_KEY!
    },
    ignoreHTTPSErrors: true
  });
  page = await context.newPage();
  await page.goto(process.env.CERT_URL!);
});

Then('I should see the landing page', async () => {
  await page.waitForSelector('text=Welcome'); // adjust selector per app
});