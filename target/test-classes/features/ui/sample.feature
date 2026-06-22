Feature: Google Search

  Scenario: Basic search
    Given I open Google
    When I search for "Playwright"
    Then results should be visible
