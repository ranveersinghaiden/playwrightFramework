Feature: Tests for PR: PR-D6D336C1

  @api @regression
  Scenario: Validate DriverLogonCardTableColumnDefinitions API response
    Given the DriverLogonCardTableColumnDefinitions API is available
    When I send a valid request to the API
    Then I should receive a successful response with correct column definitions

  @ui @regression
  Scenario: Verify DateTimeLogonCell UI rendering
    Given the DateTimeLogonCell component is displayed
    When the component is loaded with valid data
    Then the date and time should be displayed correctly

  @api @regression
  Scenario: Validate DateTimeLogonCell API response
    Given the DateTimeLogonCell API is available
    When I send a valid request to the API
    Then I should receive a successful response with correct date and time data

  @api @regression
  Scenario: Validate DriverCell API response
    Given the DriverCell API is available
    When I send a valid request to the API
    Then I should receive a successful response with correct driver data

  @api @regression
  Scenario: Validate LocationCell API response
    Given the LocationCell API is available
    When I send a valid request to the API
    Then I should receive a successful response with correct location data

  @api @regression
  Scenario: Validate StatusCell API response
    Given the StatusCell API is available
    When I send a valid request to the API
    Then I should receive a successful response with correct status data

  @api @regression
  Scenario: Validate DataRetention API response
    Given the DataRetention API is available
    When I send a valid request to the API
    Then I should receive a successful response with correct data retention information

  @api @regression
  Scenario: Validate DataRetentionPeriodUpdateModal API response
    Given the DataRetentionPeriodUpdateModal API is available
    When I send a valid request to update the data retention period
    Then the data retention period should be updated successfully

  @api @regression
  Scenario: Validate OfflineNotifications API response
    Given the OfflineNotifications API is available
    When I send a valid request to the API
    Then I should receive a successful response with correct offline notification data

  @ui @regression
  Scenario: Verify api.spec UI functionality
    Given the api.spec component is displayed
    When the component is loaded with valid data
    Then the UI should function correctly without errors

  @api @regression
  Scenario: Validate api API response
    Given the api API is available
    When I send a valid request to the API
    Then I should receive a successful response with correct API data

  @api @regression
  Scenario: Validate SettingsToggle API response
    Given the SettingsToggle API is available
    When I send a valid request to toggle settings
    Then the settings should be toggled successfully

  @api @regression
  Scenario: Validate types API response
    Given the types API is available
    When I send a valid request to the API
    Then I should receive a successful response with correct type definitions

