Feature: Tests for PR: PR-D6D336C1

  @api @regression
  Scenario: Validate DriverLogonCardTableColumnDefinitions API response
    Given the DriverLogonCardTableColumnDefinitions API is available
    When I send a valid request to the API
    Then I should receive a successful response with the correct column definitions

  @ui @regression
  Scenario: Verify DateTimeLogonCell UI rendering
    Given I am on the dashboard page
    When the DateTimeLogonCell component is loaded
    Then the cell should display the correct date and time format

  @api @regression
  Scenario: Validate DateTimeLogonCell API response
    Given the DateTimeLogonCell API is available
    When I send a valid request to the API
    Then I should receive a successful response with the correct date and time data

  @api @regression
  Scenario: Validate DriverCell API response
    Given the DriverCell API is available
    When I send a valid request to the API
    Then I should receive a successful response with the correct driver information

  @api @regression
  Scenario: Validate LocationCell API response
    Given the LocationCell API is available
    When I send a valid request to the API
    Then I should receive a successful response with the correct location data

  @api @regression
  Scenario: Validate StatusCell API response
    Given the StatusCell API is available
    When I send a valid request to the API
    Then I should receive a successful response with the correct status information

  @api @regression
  Scenario: Validate DataRetention API functionality
    Given the DataRetention API is available
    When I send a valid request to retrieve retention policies
    Then I should receive a successful response with the correct retention policy data

  @api @regression
  Scenario: Validate DataRetentionPeriodUpdateModal API functionality
    Given the DataRetentionPeriodUpdateModal API is available
    When I send a valid request to update the retention period
    Then the retention period should be updated successfully

  @api @regression
  Scenario: Validate OfflineNotifications API response
    Given the OfflineNotifications API is available
    When I send a valid request to the API
    Then I should receive a successful response with the correct offline notification data

  @ui @regression
  Scenario: Verify api.spec UI rendering
    Given I am on the settings page
    When the api.spec component is loaded
    Then the UI should display the correct API settings

  @api @regression
  Scenario: Validate api API functionality
    Given the api endpoint is available
    When I send a valid request to the API
    Then I should receive a successful response with the expected data

  @api @regression
  Scenario: Validate SettingsToggle API functionality
    Given the SettingsToggle API is available
    When I send a valid request to toggle a setting
    Then the setting should be toggled successfully

  @api @regression
  Scenario: Validate types API functionality
    Given the types API is available
    When I send a valid request to retrieve type definitions
    Then I should receive a successful response with the correct type definitions

