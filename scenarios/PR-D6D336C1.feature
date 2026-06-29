Feature: Tests for PR: PR-D6D336C1

  @happy
  Scenario: Display formatted date and time in the default timezone
    Given I have a valid ISO date-time string
    When I display the date and time in the dashcam interface
    Then the date and time should be formatted correctly according to the default timezone

  @alt_flow
  Scenario: Display formatted date and time in a specified timezone
    Given I have a valid ISO date-time string
      And I specify a valid timezone
    When I display the date and time in the dashcam interface
    Then the date and time should be formatted correctly according to the specified timezone

  @boundary
  Scenario: Display formatted date and time for boundary values
    Given I have a date-time value at the minimum supported date
      And I have a date-time value at the maximum supported date
      And I do not provide a date-time value
    When I display the date and time in the dashcam interface
      And I display the date and time in the dashcam interface
      And I display the date and time in the dashcam interface
    Then the date and time should be formatted correctly
      And no errors should occur
      And the date and time should be formatted correctly
      And no errors should occur
      And nothing should be rendered

  @negative
  Scenario: Handle invalid date-time input gracefully
    Given I provide an invalid date-time string
    When I display the date and time in the dashcam interface
    Then an error message should be shown
      And the system should not crash

  @auth
  Scenario: Display formatted date and time with insufficient permissions
    Given I am an unauthenticated user
    When I attempt to display a formatted date and time in the dashcam interface
    Then I should receive a forbidden error

  @error_resilience
  Scenario: Handle downstream failure when displaying date and time
    Given the date-time formatting service is unavailable
    When I attempt to display a formatted date and time in the dashcam interface
    Then an error message should be shown
      And the system should retry the operation

  @compat
  Scenario: Ensure backward compatibility for date-time formatting
    Given I use a previous version of the API
    When I display a formatted date and time in the dashcam interface
    Then the date and time should be formatted correctly according to the default timezone

  @happy
  Scenario: Retrieve dashcam data with default filters and sorting
    Given I have valid credentials
    When I request dashcam data without specifying filters or sorting
    Then I should receive all available dashcam data sorted by default criteria

  @alt_flow
  Scenario: Retrieve dashcam data with specific filters and sorting
    Given I have valid credentials
      And I specify asset IDs and health statuses as filters
      And I specify sorting by a specific property in descending order
    When I request dashcam data
    Then I should receive filtered and sorted dashcam data

  @boundary
  Scenario: Retrieve dashcam data with boundary filter values
    Given I have valid credentials
      And I specify the minimum and maximum asset IDs as filters
      And I have valid credentials
      And I specify no asset IDs or health statuses as filters
    When I request dashcam data
      And I request dashcam data
    Then I should receive data for the specified asset IDs
      And no errors should occur
      And I should receive all available dashcam data

  @negative
  Scenario: Handle invalid filters or sorting parameters
    Given I provide an invalid asset ID as a filter
    When I request dashcam data
    Then I should receive an error message
      And the system should not crash

  @auth
  Scenario: Retrieve dashcam data with insufficient permissions
    Given I am an unauthenticated user
    When I attempt to retrieve dashcam data
    Then I should receive a forbidden error

  @error_resilience
  Scenario: Handle downstream failure when retrieving dashcam data
    Given the dashcam data service is unavailable
    When I attempt to retrieve dashcam data
    Then an error message should be shown
      And the system should retry the operation

  @compat
  Scenario: Ensure backward compatibility for dashcam data retrieval
    Given I use a previous version of the API
    When I retrieve dashcam data
    Then I should receive data in the expected format

  @happy
  Scenario: Assign a dashcam to a machine
    Given I have valid credentials
      And I provide a valid machine ID and dashcam configuration
    When I assign a dashcam to the machine
    Then the dashcam should be successfully assigned to the machine

  @alt_flow
  Scenario: Reassign a dashcam to a new machine
    Given I have valid credentials
      And I provide a valid current machine ID and a new machine ID
    When I reassign the dashcam to the new machine
    Then the dashcam should be successfully reassigned

  @boundary
  Scenario: Check machine availability for dashcam assignment with boundary values
    Given I have valid credentials
      And I provide the minimum and maximum machine IDs
    When I check the availability of the machines for dashcam assignment
    Then I should receive the availability status for the machines

  @negative
  Scenario: Handle invalid dashcam assignment payload
    Given I provide an invalid machine ID in the assignment payload
    When I attempt to assign a dashcam to the machine
    Then I should receive an error message
      And the system should not crash

  @auth
  Scenario: Assign a dashcam with insufficient permissions
    Given I am an unauthenticated user
    When I attempt to assign a dashcam to a machine
    Then I should receive a forbidden error

  @error_resilience
  Scenario: Handle downstream failure during dashcam assignment
    Given the dashcam assignment service is unavailable
    When I attempt to assign a dashcam to a machine
    Then an error message should be shown
      And the system should retry the operation

  @compat
  Scenario: Ensure backward compatibility for dashcam assignment
    Given I use a previous version of the API
    When I assign a dashcam to a machine
    Then the assignment should be successful

  @happy
  Scenario: Retrieve snapshots for a specific dashcam
    Given I have valid credentials
      And I provide a valid dashcam ID
    When I request snapshots for the dashcam
    Then I should receive the snapshots for the specified dashcam

  @alt_flow
  Scenario: Retrieve available dashcam products for a machine and dashcam
    Given I have valid credentials
      And I provide a valid machine ID and dashcam ID
    When I request available dashcam products
    Then I should receive a list of available products for the specified machine and dashcam

  @boundary
  Scenario: Fetch the count of add-ons for a specific machine with boundary values
    Given I have valid credentials
      And I provide the minimum and maximum machine IDs
    When I request the count of add-ons for the machines
    Then I should receive the correct count for each machine

  @negative
  Scenario: Handle invalid dashcam-related data requests
    Given I provide an invalid dashcam ID
    When I request snapshots for the dashcam
    Then I should receive an error message
      And the system should not crash

  @auth
  Scenario: Retrieve dashcam-related data with insufficient permissions
    Given I am an unauthenticated user
    When I attempt to retrieve dashcam-related data
    Then I should receive a forbidden error

  @error_resilience
  Scenario: Handle downstream failure when retrieving dashcam-related data
    Given the dashcam data service is unavailable
    When I attempt to retrieve dashcam-related data
    Then an error message should be shown
      And the system should retry the operation

  @compat
  Scenario: Ensure backward compatibility for dashcam-related data retrieval
    Given I use a previous version of the API
    When I retrieve dashcam-related data
    Then I should receive data in the expected format

