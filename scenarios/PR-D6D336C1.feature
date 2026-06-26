Feature: Tests for PR: PR-D6D336C1

  @api @smoke
  Scenario: DriverLogonCardTableColumnDefinitions exposes all required column definitions
    When the DriverLogonCard table column definitions are loaded
    Then the column list includes a "dateTime" column
      And the column list includes a "driver" column
      And the column list includes a "location" column
      And the column list includes a "status" column
      And each column definition has a non-null "id" and "header" field

  @api @regression
  Scenario: DriverLogonCardTableColumnDefinitions cellRenderer fields are typed functions not any
    When the DriverLogonCard table column definitions are loaded
    Then each column definition "cellRenderer" is a typed callable function
      And no column definition field is typed as "$TSFixMe" or "any"

  @api @regression
  Scenario: DriverLogonCardTableColumnDefinitions optional width field is handled without runtime error
    Given a column definition has no optional "width" field
    When the DriverLogonCard table column definitions are loaded
    Then the column definition is returned without errors
      And no runtime exception is thrown for the missing optional field

  @ui @smoke
  Scenario: DateTimeLogonCell renders a valid logon timestamp in local time
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
  Scenario: DateTimeLogonCell reflects the correct local date when UTC timestamp crosses midnight
    Given a driver logon event with UTC timestamp "2024-03-15T23:59:59Z"
      And the user's timezone is "Pacific/Auckland"
    When the DateTimeLogonCell component renders
    Then the displayed date reflects "16 Mar 2024" in the Auckland timezone

  @api @smoke
  Scenario: DateTimeLogonCell API contract returns a strongly typed ISO 8601 timestamp field
    When driver logon events are requested from the dashcam API
    Then each logon event "timestamp" field is typed as an ISO 8601 string or explicit null
      And the timestamp field is not typed as "$TSFixMe" or "any"

  @api @regression
  Scenario: DateTimeLogonCell surfaces a typed validation error for a malformed timestamp
    Given the backend returns a logon event with timestamp "not-a-date"
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
  Scenario: DriverCell API contract returns strongly typed driver data without any fields
    When driver logon card data is requested from the dashcam API
    Then each driver entry "driverId" is typed as string
      And each driver entry "name" is typed as string or explicit null
      And no driver field resolves to "$TSFixMe" or "any"

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
  Scenario: LocationCell API contract returns strongly typed coordinate fields
    When logon event location data is requested from the dashcam API
    Then each location "latitude" is typed as number or explicit null
      And each location "longitude" is typed as number or explicit null
      And no location field resolves to "$TSFixMe" or "any"

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
  Scenario: StatusCell renders a typed fallback label for an unrecognised status value
    Given a logon event with status "UNKNOWN_STATUS"
    When the StatusCell component renders
    Then the cell displays a fallback label
      And no JavaScript runtime error is thrown

  @api @regression
  Scenario: StatusCell API contract returns a strongly typed status enum not typed as any
    When logon event data is requested from the dashcam API
    Then each event "status" is one of the defined status enum values
      And no status field resolves to "$TSFixMe" or "any"

  @api @smoke
  Scenario: DataRetention settings endpoint returns a typed retention period
    When the dashcam data retention settings are requested
    Then the response includes "retentionPeriodDays" typed as a positive integer
      And no settings field resolves to "$TSFixMe" or "any"

  @api @regression
  Scenario: DataRetention returns a typed default or 404 when no configuration exists
    Given no data retention configuration exists for the organisation
    When the dashcam data retention settings are requested
    Then the API returns either a 404 status or a typed default configuration object
      And the response body contains a human-readable error or default message

  @api @regression
  Scenario: DataRetention API response contains no untyped fields after TSFixMe removal
    When the dashcam data retention settings are requested
    Then each field in the settings response has its declared TypeScript type
      And no settings field is typed as "$TSFixMe"

  @api @smoke
  Scenario: DataRetentionPeriodUpdateModal submits a valid retention period update
    Given the DataRetentionPeriodUpdateModal is open with current period "14" days
      And I enter "30" as the new retention period in days
    When I confirm the update
    Then the API receives an update request with "retentionPeriodDays" equal to 30
      And the modal closes on a successful response

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal rejects a retention period below the minimum allowed
    Given the DataRetentionPeriodUpdateModal is open
      And I enter "0" as the new retention period in days
    When I attempt to confirm the update
    Then a typed validation error is displayed
      And no API update request is made

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal displays a typed error notification on API failure
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
    Then a validation error indicates that a number is required
      And no API update request is made

  @api @smoke
  Scenario: OfflineNotifications raises a typed alert when a dashcam device goes offline
    Given dashcam device "CAM-001" is online
    When device "CAM-001" transitions to offline
    Then an offline notification is raised for "CAM-001"
      And the notification payload includes the device identifier and an ISO 8601 "offlineSince" timestamp

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
      And each notification contains the correct typed device identifier

  @api @regression
  Scenario: OfflineNotifications API contract returns strongly typed notification payloads
    When active offline notifications are requested from the dashcam API
    Then each notification "deviceId" is typed as string
      And each notification "offlineSince" is a typed ISO 8601 string
      And no notification field resolves to "$TSFixMe" or "any"

  @api @smoke
  Scenario: Dashcam API module exports all required endpoint functions with correct typed signatures
    When the dashcam API module is loaded
    Then it exports a typed function for retrieving driver logon cards
      And it exports a typed function for updating data retention settings
      And it exports a typed function for retrieving offline notifications

  @api @regression
  Scenario: Dashcam API module surfaces a typed timeout error when the endpoint does not respond
    Given the dashcam API endpoint exceeds the configured request timeout
    When a dashcam API call is made
    Then the error returned is a typed timeout error object
      And no untyped "$TSFixMe" or "any" error is propagated to the calling component

  @api @regression
  Scenario: Dashcam API module returns a typed error object on HTTP 401 Unauthorised
    Given the backend returns a 401 Unauthorised response
    When the dashcam API module makes a request
    Then the API module returns a typed error object with status 401
      And the error message is accessible as a typed string field

  @ui @smoke
  Scenario: Dashcam API module returns correctly typed response objects for logon card data
    When the UI requests driver logon card data via the dashcam API module
    Then the response is validated against the expected TypeScript interface
      And no field in the response resolves to "$TSFixMe" or "any"

  @ui @regression
  Scenario: Dashcam API module rejects a malformed response with a typed schema error
    Given the backend returns a logon card response with a missing required field
    When the UI requests driver logon card data via the dashcam API module
    Then the API module returns a typed schema error
      And the error does not surface as an untyped runtime exception

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
  Scenario: SettingsToggle API contract rejects any non-boolean setting value
    When a settings toggle update request is submitted with a non-boolean value
    Then the request is rejected with a typed validation error
      And no setting field in the payload resolves to "$TSFixMe" or "any"

  @api @smoke
  Scenario: DriverLogonEvent type includes all required fields with correct declared types
    When the dashcam types module is loaded
    Then the DriverLogonEvent type includes "driverId" typed as string
      And the DriverLogonEvent type includes "timestamp" typed as string
      And the DriverLogonEvent type includes "location" typed as a coordinate object or null
      And the DriverLogonEvent type includes "status" typed as the status enum

  @api @smoke
  Scenario: No exported dashcam type contains a $TSFixMe or untyped any field
    When the dashcam types module is inspected
    Then no exported type contains a field typed as "$TSFixMe"
      And no exported type contains a field typed as "any"

  @api @regression
  Scenario: DataRetention type includes a strongly typed retentionPeriodDays field
    When the dashcam types module is loaded
    Then the DataRetention type includes "retentionPeriodDays" typed as number
      And the DataRetention type includes the organisation identifier typed as string

  @api @regression
  Scenario: OfflineNotification type includes all required fields with correct types
    When the dashcam types module is loaded
    Then the OfflineNotification type includes "deviceId" typed as string
      And the OfflineNotification type includes "offlineSince" typed as string
      And no OfflineNotification field is typed as nullable "any"

  @api @smoke
  Scenario: All dashcam domain components compile without type errors after VSF-3500 Part 1 changes
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

