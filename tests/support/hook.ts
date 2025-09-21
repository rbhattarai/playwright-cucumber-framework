import { Before, After, setDefaultTimeout } from '@cucumber/cucumber';
import { CustomWorld } from './world';

setDefaultTimeout(60 * 1000); // 60 seconds

Before(async function(this: CustomWorld) {
  console.log('🌟 Starting scenario...');
  await this.initBrowser();
});

After(async function(this: CustomWorld) {
  console.log('🌟 Ending scenario...');
  await this.closeBrowser();
});
