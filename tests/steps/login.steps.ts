import { Given, Then } from '@cucumber/cucumber';
import { CustomWorld } from '@support/world';
import { TableHelper } from '../utils/TableHelper.ts'


Given('I open Google', async function(this: CustomWorld) {
  await this.page.goto('https://www.google.com');
  await this.page.waitForLoadState('networkidle');
});

Then('The title should contain {string}', async function(this: CustomWorld, title: string) {
  const pageTitle = await this.page.title();
  await this.page.waitForLoadState('networkidle');
  if (!pageTitle.includes(title)) {
    throw new Error(`Expected title to include "${title}" but got "${pageTitle}"`);
  }
  TableHelper.print("Test Table");
});
