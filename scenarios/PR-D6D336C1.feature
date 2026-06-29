Feature: Tests for PR: PR-D6D336C1

  @happy
  Scenario: Displaying formatted date and time in the primary success path
    Given a dashcam logon record with a valid ISO date string
    When the logon record is displayed
    Then the date and time should be formatted correctly with the appropriate timezone

  @alt_flow
  Scenario: Displaying formatted date and time with alternate valid inputs
    Given a dashcam logon record with a valid Date object
    When the logon record is displayed
    Then the date and time should be formatted correctly with the appropriate timezone

  @boundary
  Scenario: Displaying formatted date and time with boundary values
    Given a dashcam logon record with the minimum possible date value
      And a dashcam logon record with the maximum possible date value
      And a dashcam logon record with no date provided
    When the logon record is displayed
      And the logon record is displayed
      And the logon record is displayed
    Then the date and time should be formatted correctly with the appropriate timezone
      And the date and time should be formatted correctly with the appropriate timezone
      And no date or time should be rendered

  @negative
  Scenario: Handling invalid date input gracefully
    Given a dashcam logon record with an invalid date format
    When the logon record is displayed
    Then an error message should be displayed instead of the date and time

  @auth
  Scenario: Displaying date and time with role-based access control
    Given a user with insufficient permissions views a dashcam logon record
    When the logon record is displayed
    Then the date and time should not be visible

  @error_resilience
  Scenario: Handling downstream failures when displaying date and time
    Given the system encounters a timeout while fetching the timezone data
    When the logon record is displayed
    Then a default timezone should be used to format the date and time

  @compat
  Scenario: Ensuring backward compatibility for date and time display
    Given a dashcam logon record created in a previous version of the system
    When the logon record is displayed
    Then the date and time should be formatted correctly with the appropriate timezone

