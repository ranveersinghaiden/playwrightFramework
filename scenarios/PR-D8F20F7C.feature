Feature: Tests for PR: PR-D8F20F7C

  @ui @smoke @regression
  Scenario: Display vehicle alerts on VehicleAlertsCard
    Given I am on the Vehicle Alerts page
    When the page loads
    Then I should see the VehicleAlertsCard component displayed
      And it should show the correct alerts for vehicles with missing machine states

  @ui @regression
  Scenario: Display replay list on ReplayList component
    Given I am on the Replay List page
    When the page loads
    Then I should see the ReplayList component displayed
      And it should list all replay items including those with missing machine states

  @api @regression
  Scenario: Fetch replay list data via API
    Given the ReplayList API is available
    When I send a request to fetch replay list data
    Then the API should return a response with status code 200
      And the response should include replay items with missing machine states

  @ui @regression
  Scenario: Grouped list state in useGroupedListState component
    Given I am using the useGroupedListState component
    When I group items in the list
    Then the grouped list should include items with missing machine states

  @api @regression
  Scenario: Fetch grouped list state via API
    Given the useGroupedListState API is available
    When I send a request to fetch grouped list state data
    Then the API should return a response with status code 200
      And the response should include grouped list items with missing machine states

