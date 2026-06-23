Feature: Tests for PR: PR-D6D336C1

  @api @regression
  Scenario: Validate DriverLogonCardTableColumnDefinitions API functionality
    Given the DriverLogonCardTableColumnDefinitions API is available
    When a valid request is sent to the API
    Then the API should return the correct column definitions for driver logon cards

  @ui @regression
  Scenario: Verify DateTimeLogonCell UI rendering
    Given the DateTimeLogonCell component is loaded
    When the component is provided with valid date and time data
    Then the UI should display the date and time correctly

  @api @regression
  Scenario: Validate DateTimeLogonCell API functionality
    Given the DateTimeLogonCell API is available
    When a valid request is sent to the API
    Then the API should return the correct date and time data

  @api @regression
  Scenario: Validate DriverCell API functionality
    Given the DriverCell API is available
    When a valid request is sent to the API
    Then the API should return the correct driver information

  @api @regression
  Scenario: Validate LocationCell API functionality
    Given the LocationCell API is available
    When a valid request is sent to the API
    Then the API should return the correct location data

  @api @regression
  Scenario: Validate StatusCell API functionality
    Given the StatusCell API is available
    When a valid request is sent to the API
    Then the API should return the correct status information

  @api @regression
  Scenario: Validate DataRetention API functionality
    Given the DataRetention API is available
    When a valid request is sent to the API
    Then the API should return the correct data retention details

  @api @regression
  Scenario: Validate DataRetentionPeriodUpdateModal API functionality
    Given the DataRetentionPeriodUpdateModal API is available
    When a valid request is sent to the API
    Then the API should update the data retention period successfully

  @api @regression
  Scenario: Validate OfflineNotifications API functionality
    Given the OfflineNotifications API is available
    When a valid request is sent to the API
    Then the API should return the correct offline notification details

  @ui @regression
  Scenario: Verify api.spec UI rendering
    Given the api.spec component is loaded
    When the component is provided with valid data
    Then the UI should display the data correctly

  @api @regression
  Scenario: Validate api API functionality
    Given the api API is available
    When a valid request is sent to the API
    Then the API should return the correct data

  @api @regression
  Scenario: Validate SettingsToggle API functionality
    Given the SettingsToggle API is available
    When a valid request is sent to the API
    Then the API should toggle the settings successfully

  @api @regression
  Scenario: Validate types API functionality
    Given the types API is available
    When a valid request is sent to the API
    Then the API should return the correct type definitions

