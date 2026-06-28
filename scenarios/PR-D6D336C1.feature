Feature: Tests for PR: PR-D6D336C1

  Scenario: Display driver logon records with properly formatted date and time values
    Given a driver logon record with a date and time value in ISO string format
    When the record is displayed in the DriverLogonCardTable
    Then the date and time should be displayed with the correct time zone

  Scenario: Retrieve dashcam data with filtering and sorting options
    Given a user wants to fetch dashcam data
    When the user applies filters for asset IDs and health statuses
      And sorts the data by serial number
    Then the system should return the filtered and sorted dashcam data

  Scenario: Assign a dashcam to a machine
    Given a dashcam is available for assignment
      And a machine is available for dashcam assignment
    When the user assigns the dashcam to the machine with the specified payload
    Then the system should successfully assign the dashcam to the machine

  Scenario: Reassign a dashcam to a new machine
    Given a dashcam is currently assigned to a machine
      And a new machine is available for reassignment
    When the user reassigns the dashcam to the new machine with the updated payload
    Then the system should successfully reassign the dashcam to the new machine

  Scenario: Uninstall a dashcam from a machine
    Given a dashcam is currently installed on a machine
    When the user uninstalls the dashcam using the dashcam and machine identifiers
    Then the system should successfully uninstall the dashcam

  Scenario: Retrieve snapshots for a specific dashcam
    Given a dashcam identifier is provided
    When the user retrieves snapshots for the dashcam
    Then the system should return the snapshots associated with the dashcam

  Scenario: Fetch the count of add-ons for a specific machine
    Given a machine identifier is provided
    When the user fetches the count of add-ons for the machine
    Then the system should return the correct count of add-ons

  Scenario: Retrieve available dashcam products for a machine
    Given a machine and dashcam are specified
    When the user retrieves available dashcam products for the machine
    Then the system should return the list of available dashcam products

  Scenario: Check machine availability for dashcam assignment
    Given a machine identifier is provided
    When the user checks the availability of the machine for dashcam assignment
    Then the system should indicate whether the machine is available for assignment

