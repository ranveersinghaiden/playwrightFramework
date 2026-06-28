Feature: Tests for PR: PR-D6D336C1

  @VSF-3500
  Scenario: Display formatted date and time with time zone information
    Given a dashcam record with a valid ISO date-time string
    When the record is displayed
    Then the date and time should be formatted with time zone information

  @VSF-3500
  Scenario: Display nothing when no date-time value is provided
    Given a dashcam record with no date-time value
    When the record is displayed
    Then no date-time element should be rendered

  @VSF-3500
  Scenario: Fetch dashcam data with filtering, sorting, and pagination
    Given I apply filters for dashcam status and date range
      And I sort the dashcam data by last updated time
    When I navigate to the next page of results
    Then I should see the next set of filtered and sorted dashcam data

  @VSF-3500
  Scenario: Retrieve snapshots for a specific dashcam
    Given I select a specific dashcam
    When I request the snapshots for the selected dashcam
    Then I should see a list of snapshots associated with the dashcam

  @VSF-3500
  Scenario: Assign a dashcam to a machine with configurations and plans
    Given I select a dashcam and a machine
      And I configure the dashcam with specific settings and plans
    When I assign the dashcam to the machine
    Then the dashcam should be successfully assigned to the machine with the specified configurations

  @VSF-3500
  Scenario: Fetch the count of add-ons for a specific machine
    Given I select a machine
    When I request the count of add-ons for the machine
    Then I should see the total number of add-ons available for the machine

  @VSF-3500
  Scenario: Retrieve available dashcam products for a specific machine and dashcam
    Given I select a machine and a dashcam
    When I request the available dashcam products
    Then I should see a list of compatible dashcam products for the selected machine and dashcam

  @VSF-3500
  Scenario: Check the availability of a machine for dashcam assignment
    Given I select a machine
    When I check the machine's availability for dashcam assignment
    Then I should see whether the machine is available for assignment

  @VSF-3500
  Scenario: Reassign a dashcam from one machine to another
    Given a dashcam is currently assigned to a machine
      And I select a new machine for reassignment
    When I reassign the dashcam to the new machine
    Then the dashcam should be successfully reassigned to the new machine

