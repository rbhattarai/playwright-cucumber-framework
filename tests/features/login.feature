Feature: Example Playwright Cucumber Test

  @SmokeTest
  Scenario: Open Google and check title
    Given I open Google
    Then The title should contain "Google"
