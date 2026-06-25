Feature: Tests for PR: PR-D8F20F7C

  @ui @smoke
  Scenario: VehicleAlertsCard renders alert count including records with missing machine state
    Given a vehicle has openDriverLog records where machine state is null
    When the VehicleAlertsCard component is rendered for that vehicle
    Then the alert card displays the correct total count including records with no machine state
      And no records are silently dropped from the alert summary

  @ui @regression
  Scenario: VehicleAlertsCard renders alert count when all records have a valid machine state
    Given a vehicle has openDriverLog records each with a valid machine state
    When the VehicleAlertsCard component is rendered for that vehicle
    Then the alert card displays the full record count
      And machine state details are shown alongside each alert entry

  @ui @regression
  Scenario: VehicleAlertsCard shows empty state when the vehicle has no openDriverLog records
    Given a vehicle has no openDriverLog records
    When the VehicleAlertsCard component is rendered for that vehicle
    Then the alert card displays an empty state indicator
      And the alert count is zero

  @ui @regression
  Scenario: VehicleAlertsCard renders correctly when openDriverLog records mix present and absent machine state
    Given a vehicle has 3 openDriverLog records with valid machine state and 2 with null machine state
    When the VehicleAlertsCard component is rendered for that vehicle
    Then the alert count equals 5
      And all 5 records are visible without errors

  @ui @smoke
  Scenario: ReplayList displays openDriverLog entries when machine state is absent
    Given openDriverLog records exist where machine state is null
    When the ReplayList component is rendered
    Then all openDriverLog records appear in the replay list
      And records with null machine state are not filtered out

  @ui @regression
  Scenario: ReplayList displays openDriverLog entries when machine state is present
    Given openDriverLog records exist each with a populated machine state
    When the ReplayList component is rendered
    Then all records appear in the replay list in chronological order
      And machine state information is visible for each record

  @ui @regression
  Scenario: ReplayList shows an empty state when there are no openDriverLog records
    Given no openDriverLog records exist for the selected time range
    When the ReplayList component is rendered
    Then the replay list shows the empty state message
      And no list items are rendered

  @ui @regression
  Scenario: ReplayList preserves record order when machine state is partially missing
    Given a mix of openDriverLog records some with and some without machine state ordered by timestamp
    When the ReplayList component is rendered
    Then records appear in ascending timestamp order
      And records with null machine state are interspersed correctly without being moved to the end

  @ui @regression
  Scenario: ReplayList renders additional record details when a record without machine state is expanded
    Given an openDriverLog record with null machine state exists in the replay list
    When the user expands that record row
    Then the detail panel opens without errors
      And the machine state section shows a graceful not-available indicator

  @api @smoke
  Scenario: ReplayList API returns openDriverLog records that have no associated machine state
    Given openDriverLog records with null machine state are present in the data store
    When a GET request is sent to the ReplayList data endpoint
    Then the response status is 200
      And the response payload includes records with null machine state
      And the total count matches the full record set

  @api @regression
  Scenario: ReplayList API returns the complete record set regardless of machine state value
    Given the data store contains openDriverLog records with mixed machine state presence
    When a GET request is sent to the ReplayList data endpoint
    Then the response status is 200
      And records with a machine state and records without a machine state are both included
      And the returned count equals the sum of both groups

  @api @regression
  Scenario: ReplayList API returns an empty list when no openDriverLog records exist
    Given no openDriverLog records exist in the data store
    When a GET request is sent to the ReplayList data endpoint
    Then the response status is 200
      And the response payload contains an empty records array

  @api @regression
  Scenario: ReplayList API applies date range filters without excluding null machine state records
    Given openDriverLog records with null machine state fall within the requested date range
    When a GET request is sent to the ReplayList data endpoint with a date range filter
    Then the response includes only records within the date range
      And records with null machine state that fall within the range are present in the response

  @api @regression
  Scenario: ReplayList API paginates correctly when the result set includes null machine state records
    Given 30 openDriverLog records exist with varying machine state presence
    When a paginated GET request is sent to the ReplayList data endpoint requesting page 1 with size 10
    Then the response returns exactly 10 records
      And the pagination metadata reflects the full 30 record total

  @ui @smoke
  Scenario: useGroupedListState hook retains items with null machine state in the grouped output
    Given a list of openDriverLog items where some items have null machine state
    When the useGroupedListState hook processes the item list
    Then the hook returns a grouped structure that includes items with null machine state
      And no items are silently dropped during grouping

  @ui @regression
  Scenario: useGroupedListState hook groups items correctly when all machine states are present
    Given a list of openDriverLog items each with a populated machine state
    When the useGroupedListState hook processes the item list
    Then the hook returns groups keyed by the appropriate grouping criterion
      And every item appears in exactly one group

  @ui @regression
  Scenario: useGroupedListState hook returns an empty grouped state for an empty input list
    Given an empty list of openDriverLog items
    When the useGroupedListState hook processes the empty list
    Then the hook returns an empty grouped structure
      And no errors or exceptions are thrown

  @ui @regression
  Scenario: useGroupedListState hook updates grouped state reactively when null machine state items are added
    Given the useGroupedListState hook has been initialised with items that all have machine state
    When new openDriverLog items with null machine state are appended to the list
    Then the hook re-computes the grouped state to include the new items
      And the total item count in the grouped output increases accordingly

  @ui @regression
  Scenario: useGroupedListState hook correctly counts group totals when some items have null machine state
    Given a list of 10 openDriverLog items where 4 have null machine state
    When the useGroupedListState hook computes group totals
    Then the sum of all group item counts equals 10
      And items with null machine state contribute to group totals

  @api @smoke
  Scenario: useGroupedListState API returns grouped records that include null machine state entries
    Given openDriverLog records with null machine state exist in the data store
    When the grouped list endpoint is called
    Then the response status is 200
      And the grouped payload contains entries where machine state is null
      And those entries are not absent from any group

  @api @regression
  Scenario: useGroupedListState API groups records without excluding null machine state records
    Given the data store contains openDriverLog records with and without machine state
    When the grouped list endpoint is called
    Then the response status is 200
      And the total item count across all groups equals the total record count in the data store

  @api @regression
  Scenario: useGroupedListState API returns an empty grouping when no records exist
    Given no openDriverLog records exist in the data store
    When the grouped list endpoint is called
    Then the response status is 200
      And the response payload contains an empty groups object

  @api @regression
  Scenario: useGroupedListState API grouped response is consistent with the flat ReplayList API response
    Given openDriverLog records with and without machine state exist in the data store
    When both the ReplayList API and the grouped list API are called for the same data set
    Then the total record count from the ReplayList API equals the sum of all group sizes from the grouped list API
      And records with null machine state appear in both responses

  @api @regression
  Scenario: useGroupedListState API performance is within acceptable thresholds when processing large record sets containing null machine state
    Given 500 openDriverLog records exist of which 200 have null machine state
    When the grouped list endpoint is called
    Then the response status is 200
      And the response is returned within the defined performance SLA
      And all 500 records are accounted for across the returned groups

