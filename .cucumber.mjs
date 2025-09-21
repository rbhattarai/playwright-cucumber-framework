import { loadConfiguration } from '@cucumber/cucumber/api';

const config = await loadConfiguration({
  requireModule: ['ts-node/register', 'tsconfig-paths/register'],
  require: ['tests/steps/**/*.ts', 'tests/support/*.ts'],
  format: ['json:reports/cucumber.json']
});

export default config;
