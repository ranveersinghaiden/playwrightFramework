Feature: Tests for PR: PR-D6D336C1

  @api @regression
  Scenario: Validate DriverLogonCardTableColumnDefinitions API
    When I send a request to the DriverLogonCardTableColumnDefinitions API
    Then I should receive a successful response with correct column definitions

  @ui @regression
  Scenario: Verify DateTimeLogonCell UI rendering
    Given I navigate to the DateTimeLogonCell component
    When the component is loaded
    Then it should display the correct date and time format

  @api @regression
  Scenario: Validate DateTimeLogonCell API response
    When I send a request to the DateTimeLogonCell API
    Then I should receive a successful response with accurate date and time data

  @api @regression
  Scenario: Validate DriverCell API response
    When I send a request to the DriverCell API
    Then I should receive a successful response with correct driver information

  @api @regression
  Scenario: Validate LocationCell API response
    When I send a request to the LocationCell API
    Then I should receive a successful response with accurate location data

  @api @regression
  Scenario: Validate StatusCell API response
    When I send a request to the StatusCell API
    Then I should receive a successful response with the correct status information

  @api @regression
  Scenario: Validate DataRetention API functionality
    When I send a request to the DataRetention API
    Then I should receive a successful response with the correct data retention details

  @api @regression
  Scenario: Validate DataRetentionPeriodUpdateModal API functionality
    When I send a request to the DataRetentionPeriodUpdateModal API
    Then I should receive a successful response confirming the update of the data retention period

  @api @regression
  Scenario: Validate OfflineNotifications API functionality
    When I send a request to the OfflineNotifications API
    Then I should receive a successful response with the correct offline notification details

  @ui @regression
  Scenario: Verify api.spec UI functionality
    Given I navigate to the api.spec component
    When the component is loaded
    Then it should display the correct API specifications

  @api @regression
  Scenario: Validate api API functionality
    When I send a request to the api endpoint
    Then I should receive a successful response with the correct API data

  @api @regression
  Scenario: Validate SettingsToggle API functionality
    When I send a request to the SettingsToggle API
    Then I should receive a successful response confirming the toggle state

  @api @regression
  Scenario: Validate types API functionality
    When I send a request to the types API
    Then I should receive a successful response with the correct type definitions

