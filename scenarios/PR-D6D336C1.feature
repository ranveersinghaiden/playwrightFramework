Feature: Tests for PR: PR-D6D336C1

  @api @smoke
  Scenario: Driver logon card table exposes all required column definitions
    When I request the DriverLogonCard table column definitions
    Then the response contains a "dateTime" column definition
      And the response contains a "driver" column definition
      And the response contains a "location" column definition
      And the response contains a "status" column definition
      And each column definition has a non-null "id" and "header" field

  @api @regression
  Scenario: Driver logon card column definitions carry correct types on all fields
    When I request the DriverLogonCard table column definitions
    Then each column definition "id" is a string
      And each column definition "cellRenderer" is a callable function
      And no column definition field is untyped or resolves to "any"

  @api @regression
  Scenario: Driver logon card table column definitions handle absent optional fields gracefully
    Given a column definition has no optional "width" field
    When I request the DriverLogonCard table column definitions
    Then the column definition is returned without errors
      And the missing optional field does not cause a runtime exception

  @ui @smoke
  Scenario: DateTimeLogonCell renders a valid logon timestamp in the user's local time
    Given a driver logon event with UTC timestamp "2024-03-15T08:30:00Z"
    When the DateTimeLogonCell component renders
    Then the cell displays the date "15 Mar 2024"
      And the cell displays the time "08:30"

  @ui @regression
  Scenario: DateTimeLogonCell renders a placeholder when the timestamp is null
    Given a driver logon event with a null timestamp
    When the DateTimeLogonCell component renders
    Then the cell displays an empty or dash placeholder
      And no JavaScript runtime error is thrown

  @ui @regression
  Scenario: DateTimeLogonCell reflects the correct local date when the UTC timestamp crosses midnight
    Given a driver logon event with UTC timestamp "2024-03-15T23:59:59Z"
      And the user's timezone is "Pacific/Auckland"
    When the DateTimeLogonCell component renders
    Then the displayed date reflects "16 Mar 2024" in the Auckland timezone

  @api @smoke
  Scenario: DateTimeLogonCell API contract returns an ISO 8601 typed timestamp field
    When I request driver logon events from the dashcam API
    Then each logon event "timestamp" field is an ISO 8601 string or explicit null
      And the timestamp field is not typed as "any"

  @api @regression
  Scenario: DateTimeLogonCell API returns a typed error when the timestamp field is malformed
    Given the backend returns a logon event with a non-ISO timestamp "not-a-date"
    When the DateTimeLogonCell processes the API response
    Then a typed validation error is surfaced
      And the component does not silently render invalid date output

  @api @smoke
  Scenario: DriverCell renders the correct driver name and identifier
    Given a driver with name "Jane Doe" and driverId "DRV-101"
    When the DriverCell component renders
    Then the cell displays "Jane Doe"
      And the cell displays "DRV-101"

  @api @regression
  Scenario: DriverCell renders a fallback placeholder when the driver name is null
    Given a driver with a null name and driverId "DRV-102"
    When the DriverCell component renders
    Then the cell displays an appropriate placeholder
      And no JavaScript runtime error is thrown

  @api @regression
  Scenario: DriverCell API contract returns strongly typed driver data
    When I request driver logon card data from the dashcam API
    Then each driver entry has a "driverId" of type string
      And each driver entry has a "name" typed as string or null
      And no driver field resolves to "any"

  @api @smoke
  Scenario: LocationCell renders a human-readable location for a logon event
    Given a logon event with latitude "-36.8485" and longitude "174.7633"
    When the LocationCell component renders
    Then the cell displays a non-empty location string

  @api @regression
  Scenario: LocationCell renders a placeholder when location data is null
    Given a logon event with null location data
    When the LocationCell component renders
    Then the cell displays an empty or dash placeholder
      And no JavaScript runtime error is thrown

  @api @regression
  Scenario: LocationCell API contract returns correctly typed coordinate fields
    When I request logon event location data from the dashcam API
    Then each location "latitude" is a number or explicit null
      And each location "longitude" is a number or explicit null
      And no location field resolves to "any"

  @api @smoke
  Scenario: StatusCell renders "Logged In" for an active driver session
    Given a logon event with status "LOGGED_IN"
    When the StatusCell component renders
    Then the cell displays "Logged In"
      And the active status indicator is visible

  @api @smoke
  Scenario: StatusCell renders "Logged Out" for an ended driver session
    Given a logon event with status "LOGGED_OUT"
    When the StatusCell component renders
    Then the cell displays "Logged Out"
      And the inactive status indicator is visible

  @api @regression
  Scenario: StatusCell renders a default label for an unrecognised status value
    Given a logon event with status "UNKNOWN_STATUS"
    When the StatusCell component renders
    Then the cell displays a fallback label
      And no JavaScript runtime error is thrown

  @api @regression
  Scenario: StatusCell API contract returns a strongly typed status enum value
    When I request logon event data from the dashcam API
    Then each event "status" is one of the defined enum values
      And no status field resolves to "any"

  @api @smoke
  Scenario: DataRetention settings endpoint returns a typed retention period
    When I request the dashcam data retention settings
    Then the response includes a "retentionPeriodDays" field of type number
      And the retention period value is a positive integer

  @api @regression
  Scenario: DataRetention API response does not contain any untyped fields
    When I request the dashcam data retention settings
    Then each field in the settings response has its declared TypeScript type
      And no settings field resolves to "any"

  @api @regression
  Scenario: DataRetention returns an appropriate response when no configuration exists
    Given no data retention configuration exists for the organisation
    When I request the dashcam data retention settings
    Then the API returns either a 404 status or a typed default configuration object
      And the response body contains a human-readable error or default message

  @api @smoke
  Scenario: DataRetentionPeriodUpdateModal submits a valid retention period update
    Given the DataRetentionPeriodUpdateModal is open with current period "14" days
      And I enter "30" as the new retention period in days
    When I confirm the update
    Then the API receives an update request with retentionPeriodDays equal to 30
      And the modal closes on a successful response

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal rejects a retention period below the minimum allowed
    Given the DataRetentionPeriodUpdateModal is open
      And I enter "0" as the new retention period in days
    When I attempt to confirm the update
    Then a typed validation error is displayed
      And no API update request is made

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal displays an error notification on API failure
    Given the DataRetentionPeriodUpdateModal is open
      And the retention update API returns a 500 error
    When I confirm the update
    Then a typed error notification is displayed
      And the modal remains open with the previously entered value

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal rejects non-numeric input with a typed validation message
    Given the DataRetentionPeriodUpdateModal is open
      And I enter "abc" as the new retention period
    When I attempt to confirm the update
    Then a validation error is displayed indicating that a number is required
      And no API update request is made

  @api @smoke
  Scenario: OfflineNotifications raises a typed alert when a dashcam device goes offline
    Given dashcam device "CAM-001" is online
    When device "CAM-001" transitions to offline
    Then an offline notification is raised for "CAM-001"
      And the notification payload includes the device identifier and an ISO 8601 offlineSince timestamp

  @api @smoke
  Scenario: OfflineNotifications dismisses the alert when a device reconnects
    Given dashcam device "CAM-001" has an active offline notification
    When device "CAM-001" transitions back to online
    Then the offline notification for "CAM-001" is dismissed
      And no stale notification remains visible for "CAM-001"

  @api @regression
  Scenario: OfflineNotifications raises separate typed alerts for multiple concurrent offline devices
    Given dashcam devices "CAM-001", "CAM-002", and "CAM-003" are all online
    When all three devices transition to offline simultaneously
    Then three separate offline notifications are raised
      And each notification contains the correct device identifier

  @api @regression
  Scenario: OfflineNotifications API contract returns strongly typed notification payloads
    When I request active offline notifications from the dashcam API
    Then each notification has a "deviceId" of type string
      And each notification has an "offlineSince" ISO 8601 string
      And no notification field resolves to "any"

  @ui @smoke
  Scenario: Dashcam API module returns correctly typed response objects for logon card data
    When the UI requests driver logon card data via the dashcam API module
    Then the response is validated against the expected TypeScript interface
      And no field in the response resolves to "any"

  @ui @regression
  Scenario: Dashcam API module propagates typed error objects on HTTP failures
    Given the backend returns a 401 Unauthorised response
    When the UI requests dashcam data via the API module
    Then the API module returns a typed error object with status 401
      And the error message is accessible as a typed string field

  @api @smoke
  Scenario: Dashcam API module exports all required endpoint functions with correct signatures
    When the dashcam API module is loaded
    Then it exports a typed function for retrieving driver logon cards
      And it exports a typed function for updating data retention settings
      And it exports a typed function for retrieving offline notifications

  @api @regression
  Scenario: Dashcam API module surfaces a typed timeout error when the endpoint does not respond
    Given the dashcam API endpoint exceeds the configured request timeout
    When a dashcam API call is made
    Then the error returned is a typed timeout error object
      And no untyped "any" error is propagated to the calling component

  @api @smoke
  Scenario: SettingsToggle renders in the enabled state when the API reports the setting as on
    Given the dashcam settings API returns "offlineNotifications" as enabled
    When the SettingsToggle for "offlineNotifications" is rendered
    Then the toggle is in the "on" position
      And the accessible label reads "Offline Notifications enabled"

  @api @smoke
  Scenario: SettingsToggle calls the update API with a typed boolean payload when toggled off
    Given the SettingsToggle for "offlineNotifications" is in the "on" position
    When I toggle "offlineNotifications" off
    Then the API receives an update request with "offlineNotifications" set to false
      And the toggle visually transitions to the "off" position

  @api @regression
  Scenario: SettingsToggle reverts to its previous state when the API update fails
    Given the SettingsToggle for "dataRetention" is in the "on" position
      And the settings update API returns a 500 error
    When I toggle "dataRetention" off
    Then a typed error notification is displayed
      And the toggle reverts to the "on" position

  @api @regression
  Scenario: SettingsToggle API contract accepts only strongly typed boolean setting values
    When a settings toggle update request is submitted
    Then the request payload contains a boolean field for the setting value
      And no setting field in the payload resolves to "any"

  @api @smoke
  Scenario: DriverLogonEvent type includes all required fields with correct declared types
    When the dashcam types module is loaded
    Then the DriverLogonEvent type includes "driverId" as string
      And the DriverLogonEvent type includes "timestamp" as string
      And the DriverLogonEvent type includes "location" as a typed coordinate or null
      And the DriverLogonEvent type includes "status" as a defined status enum

  @api @smoke
  Scenario: No exported dashcam type contains a TSFixMe or untyped any field
    When the dashcam types module is inspected
    Then no exported type contains a field typed as "$TSFixMe"
      And no exported type contains a field typed as "any"

  @api @regression
  Scenario: DataRetention type includes a strongly typed retentionPeriodDays field
    When the dashcam types module is loaded
    Then the DataRetention type includes "retentionPeriodDays" as number
      And the DataRetention type includes the organisation identifier as string

  @api @regression
  Scenario: OfflineNotification type includes all required fields with correct types
    When the dashcam types module is loaded
    Then the OfflineNotification type includes "deviceId" as string
      And the OfflineNotification type includes "offlineSince" as string
      And no OfflineNotification field is typed as nullable "any"

  @api @smoke
  Scenario: All consuming dashcam components compile without type errors after VSF-3500 Part 1 type changes
    Given the dashcam domain types have been updated in VSF-3500 Part 1
    When the TypeScript compiler builds all consuming components
    Then no type errors are reported in DriverLogonCardTableColumnDefinitions
      And no type errors are reported in DateTimeLogonCell
      And no type errors are reported in DriverCell
      And no type errors are reported in LocationCell
      And no type errors are reported in StatusCell
      And no type errors are reported in DataRetentionPeriodUpdateModal
      And no type errors are reported in OfflineNotifications
      And no type errors are reported in SettingsToggle

