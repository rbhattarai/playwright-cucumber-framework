import { Given, Then } from '@cucumber/cucumber';
import { CustomWorld } from '@support/world';


Given('I open Google', async function(this: CustomWorld) {
  await this.page.goto('https://www.google.com');
});

Then('The title should contain {string}', async function(this: CustomWorld, title: string) {
  const pageTitle = await this.page.title();
  if (!pageTitle.includes(title)) {
    throw new Error(`Expected title to include "${title}" but got "${pageTitle}"`);
  }
});
