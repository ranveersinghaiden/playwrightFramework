Feature: Tests for PR: PR-D6D336C1

  @api @regression
  Scenario: Validate DriverLogonCardTableColumnDefinitions API functionality
    Given the DriverLogonCardTableColumnDefinitions API is available
    When a request is made to retrieve column definitions for driver logon cards
    Then the response should contain valid column definitions
      And the response status should be 200

  @ui @regression
  Scenario: Verify DateTimeLogonCell UI rendering
    Given the DateTimeLogonCell component is displayed on the dashboard
    When the component is loaded with valid date and time data
    Then the UI should render the date and time correctly
      And there should be no visual defects

  @api @regression
  Scenario: Validate DateTimeLogonCell API functionality
    Given the DateTimeLogonCell API is available
    When a request is made to retrieve date and time data for logon cells
    Then the response should contain valid date and time data
      And the response status should be 200

  @api @regression
  Scenario: Validate DriverCell API functionality
    Given the DriverCell API is available
    When a request is made to retrieve driver information
    Then the response should contain valid driver details
      And the response status should be 200

  @api @regression
  Scenario: Validate LocationCell API functionality
    Given the LocationCell API is available
    When a request is made to retrieve location data for a driver
    Then the response should contain valid location details
      And the response status should be 200

  @api @regression
  Scenario: Validate StatusCell API functionality
    Given the StatusCell API is available
    When a request is made to retrieve status information for a driver
    Then the response should contain valid status details
      And the response status should be 200

  @api @regression
  Scenario: Validate DataRetention API functionality
    Given the DataRetention API is available
    When a request is made to retrieve data retention policies
    Then the response should contain valid retention policy details
      And the response status should be 200

  @api @regression
  Scenario: Validate DataRetentionPeriodUpdateModal API functionality
    Given the DataRetentionPeriodUpdateModal API is available
    When a request is made to update the data retention period
    Then the response should confirm the update was successful
      And the response status should be 200

  @api @regression
  Scenario: Validate OfflineNotifications API functionality
    Given the OfflineNotifications API is available
    When a request is made to retrieve offline notification settings
    Then the response should contain valid notification settings
      And the response status should be 200

  @ui @regression
  Scenario: Verify API UI rendering
    Given the API UI component is displayed on the dashboard
    When the component is loaded with valid API data
    Then the UI should render the API data correctly
      And there should be no visual defects

  @api @regression
  Scenario: Validate API functionality
    Given the API is available
    When a request is made to retrieve general API data
    Then the response should contain valid API data
      And the response status should be 200

  @api @regression
  Scenario: Validate SettingsToggle API functionality
    Given the SettingsToggle API is available
    When a request is made to toggle a setting
    Then the response should confirm the toggle action was successful
      And the response status should be 200

  @api @regression
  Scenario: Validate types API functionality
    Given the types API is available
    When a request is made to retrieve type definitions
    Then the response should contain valid type definitions
      And the response status should be 200

