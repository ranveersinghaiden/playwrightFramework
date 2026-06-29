Feature: Tests for PR: PR-D6D336C1

  @happy
  Scenario: Displaying a valid date-time with time zone
    Given a dashcam driver logon record with a valid ISO date-time string
    When the system displays the logon record
    Then the date and time should be formatted correctly with the time zone

  @alt_flow
  Scenario: Displaying a date-time with alternate valid formats
    Given a dashcam driver logon record with a valid Date object
    When the system displays the logon record
    Then the date and time should be formatted correctly with the time zone
      And the format should match the expected standard

  @boundary
  Scenario: Displaying date-time with boundary values
    Given a dashcam driver logon record with the earliest possible date-time
    When the system displays the logon record
    Then the date and time should be formatted correctly with the time zone
      And the displayed value should match the input

  @negative
  Scenario: Handling invalid date-time input
    Given a dashcam driver logon record with an invalid date-time value
    When the system attempts to display the logon record
    Then the system should render nothing

  @auth
  Scenario: Unauthorized user attempts to view logon records
    Given an unauthenticated user
    When the user attempts to access dashcam driver logon records
    Then the system should deny access with a "403 Forbidden" error

  @error_resilience
  Scenario: Downstream failure while fetching logon records
    Given the logon records service is unavailable
    When the system attempts to fetch dashcam driver logon records
    Then the system should retry the request
      And display an error message if the retries fail

  @compat
  Scenario: Backward compatibility for date-time display
    Given a dashcam driver logon record stored in an older format
    When the system displays the logon record
    Then the date and time should be formatted correctly with the time zone

  @happy
  Scenario: Assigning a dashcam to a machine
    Given a machine is available for dashcam assignment
      And a valid payload with dashcam details, configurations, and plans
    When the user assigns the dashcam to the machine
    Then the system should confirm the assignment

  @alt_flow
  Scenario: Reassigning a dashcam to a new machine
    Given a dashcam is already assigned to a machine
      And a valid payload with the new machine ID
    When the user reassigns the dashcam to the new machine
    Then the system should confirm the reassignment

  @boundary
  Scenario: Assigning a dashcam with boundary payload values
    Given a payload with the minimum required fields for assignment
    When the user assigns the dashcam to a machine
    Then the system should confirm the assignment

  @negative
  Scenario: Invalid payload for dashcam assignment
    Given a payload with missing or invalid fields
    When the user attempts to assign the dashcam
    Then the system should reject the request with an error message

  @auth
  Scenario: Unauthorized user attempts to assign a dashcam
    Given an unauthenticated user
    When the user attempts to assign a dashcam to a machine
    Then the system should deny access with a "403 Forbidden" error

  @error_resilience
  Scenario: Downstream failure during dashcam assignment
    Given the assignment service is unavailable
    When the user attempts to assign a dashcam
    Then the system should retry the request
      And display an error message if the retries fail

  @compat
  Scenario: Backward compatibility for dashcam assignment
    Given a payload in an older format
    When the user assigns the dashcam to a machine
    Then the system should process the assignment successfully

  @happy
  Scenario: Fetching and displaying dashcam snapshots
    Given a valid dashcam identifier
    When the user retrieves snapshots for the dashcam
    Then the system should display the snapshots

  @alt_flow
  Scenario: Fetching add-ons for a machine
    Given a valid machine identifier
    When the user fetches the count of add-ons
    Then the system should display the count

  @boundary
  Scenario: Fetching data with boundary values
    Given a valid dashcam identifier with the minimum possible value
    When the user retrieves snapshots for the dashcam
    Then the system should display the snapshots

  @negative
  Scenario: Invalid dashcam identifier for data retrieval
    Given an invalid dashcam identifier
    When the user attempts to retrieve snapshots
    Then the system should reject the request with an error message

  @auth
  Scenario: Unauthorized user attempts to retrieve dashcam data
    Given an unauthenticated user
    When the user attempts to fetch dashcam-related data
    Then the system should deny access with a "403 Forbidden" error

  @error_resilience
  Scenario: Downstream failure during data retrieval
    Given the data retrieval service is unavailable
    When the user attempts to fetch dashcam-related data
    Then the system should retry the request
      And display an error message if the retries fail

  @compat
  Scenario: Backward compatibility for data retrieval
    Given a dashcam identifier stored in an older format
    When the user retrieves snapshots for the dashcam
    Then the system should display the snapshots

