Feature: Tests for PR: PR-D6D336C1

  @regression @api
  Scenario: DriverLogonCardTableColumnDefinitions returns all expected columns on a valid request
    Given the dashcam service is running and authenticated
    When the driver logon card table column definitions are retrieved
    Then the response includes columns for DateTime, Driver, Location, and Status
      And each column definition contains a key, label, and sortable flag

  @negative @api
  Scenario: DriverLogonCardTableColumnDefinitions returns an error when retrieved without required fleet context
    Given the dashcam service is running
      And no fleet context header is provided
    When the driver logon card table column definitions are requested
    Then the response status is 400
      And the error message indicates missing fleet context

  @boundary @api
  Scenario: DriverLogonCardTableColumnDefinitions handles a fleet with the maximum allowed number of custom columns
    Given a fleet configured with the maximum number of custom columns
    When the driver logon card table column definitions are retrieved for that fleet
    Then all columns up to the defined maximum are returned
      And no additional columns beyond the limit appear in the response

  @happy @api
  Scenario: DriverLogonCardTableColumnDefinitions returns correctly typed column metadata
    Given the dashcam service is running and authenticated
    When the driver logon card table column definitions are retrieved
    Then each column definition has a non-empty string key
      And each column definition has a non-empty string label
      And the sortable property is a boolean value

  @alt @api
  Scenario: DriverLogonCardTableColumnDefinitions returns localised column labels when locale header is set
    Given the dashcam service is running and authenticated
      And the request includes a locale header set to "fr-FR"
    When the driver logon card table column definitions are retrieved
    Then column labels are returned in French

  @auth @api
  Scenario: DriverLogonCardTableColumnDefinitions returns 401 for an unauthenticated request
    Given the dashcam API endpoint for column definitions is accessible
    When a request is made without an authentication token
    Then the response status is 401
      And the response body contains an authentication error

  @error @api
  Scenario: DriverLogonCardTableColumnDefinitions returns 503 when the column definition service is unavailable
    Given the column definition service dependency is down
    When the driver logon card table column definitions are requested with valid auth
    Then the response status is 503
      And the error payload indicates a service unavailable condition

  @compat @api
  Scenario: DriverLogonCardTableColumnDefinitions response schema remains backward-compatible after the TypeScript fix
    Given a stored baseline schema for driver logon card table column definitions
    When the driver logon card table column definitions are retrieved from the updated service
    Then the response schema matches the baseline schema field names and types

  @regression @ui
  Scenario: DateTimeLogonCell renders a formatted date and time for a valid logon timestamp
    Given a driver logon record with timestamp "2024-03-15T08:30:00Z"
    When the DateTimeLogonCell component is rendered for that record
    Then the cell displays "15 Mar 2024" and "08:30"
      And no console errors are thrown

  @negative @ui
  Scenario: DateTimeLogonCell renders a placeholder when the logon timestamp is null
    Given a driver logon record with a null timestamp
    When the DateTimeLogonCell component is rendered
    Then the cell displays a dash placeholder "–"
      And no unhandled type errors are logged

  @boundary @ui
  Scenario: DateTimeLogonCell correctly renders a timestamp at the epoch boundary "1970-01-01T00:00:00Z"
    Given a driver logon record with timestamp "1970-01-01T00:00:00Z"
    When the DateTimeLogonCell component is rendered
    Then the cell displays "1 Jan 1970" and "00:00"

  @happy @ui
  Scenario: DateTimeLogonCell displays date and time in the user's configured timezone
    Given the user's timezone preference is "Pacific/Auckland"
      And a driver logon record with timestamp "2024-06-01T00:00:00Z"
    When the DateTimeLogonCell component is rendered
    Then the cell displays the date and time converted to NZST

  @alt @ui
  Scenario: DateTimeLogonCell renders correctly when the timestamp is in a non-UTC timezone offset
    Given a driver logon record with timestamp "2024-03-15T08:30:00+05:30"
    When the DateTimeLogonCell component is rendered with no timezone override
    Then the cell displays a valid formatted date and time without throwing a type error

  @auth @ui
  Scenario: DateTimeLogonCell does not render sensitive driver logon time data when the user lacks view permissions
    Given the current user does not have the "dashcam.view" permission
    When the DateTimeLogonCell component is rendered inside the logon table
    Then the cell is not visible or is replaced by a restricted-access indicator

  @error @ui
  Scenario: DateTimeLogonCell renders an error state when the timestamp value is an unexpected non-string type
    Given a driver logon record whose timestamp field contains a numeric value instead of a string
    When the DateTimeLogonCell component is rendered
    Then the cell displays an error placeholder
      And a warning is emitted to the console

  @compat @ui
  Scenario: DateTimeLogonCell renders identically before and after the TSFixMe type removal refactor
    Given a snapshot of the DateTimeLogonCell output before the PR-D6D336C1 change
    When the DateTimeLogonCell component is rendered with the same props after the change
    Then the rendered output matches the pre-change snapshot

  @regression @api
  Scenario: DriverCell returns driver name and ID for a valid driver logon record
    Given a driver logon record with driverId "D001" and driverName "Jane Smith"
    When the DriverCell data is retrieved via the dashcam API
    Then the response contains driverId "D001" and driverName "Jane Smith"

  @negative @api
  Scenario: DriverCell handles a logon record where the driver has been deleted from the system
    Given a driver logon record referencing a deleted driverId "D999"
    When the DriverCell data is requested
    Then the response indicates the driver is not found
      And no 500 error is thrown

  @boundary @api
  Scenario: DriverCell renders correctly when the driver name is exactly 255 characters long
    Given a driver record with a name that is exactly 255 characters
    When the DriverCell data is retrieved
    Then the full 255-character name is returned without truncation

  @happy @api
  Scenario: DriverCell returns structured driver data including name, ID, and avatar URL
    Given an authenticated request for a valid driver logon record
    When the DriverCell data endpoint is called
    Then the response includes driverName, driverId, and avatarUrl fields

  @alt @api
  Scenario: DriverCell returns an anonymous driver placeholder when the logon was performed without a driver card
    Given a dashcam logon event recorded without a driver card
    When the DriverCell data is retrieved for that event
    Then the driverName is "Unknown Driver" and driverId is null

  @auth @api
  Scenario: DriverCell API returns 403 when the caller's role does not include driver data access
    Given a user with a role that excludes driver data permissions
    When the DriverCell API is called for a logon record
    Then the response status is 403
      And the error body references insufficient permissions

  @error @api
  Scenario: DriverCell API returns a structured error when the upstream driver service times out
    Given the driver service dependency will time out after 100ms
    When the DriverCell API is called for a valid logon record
    Then the response status is 504
      And the error message indicates a gateway timeout

  @compat @api
  Scenario: DriverCell API response shape is unchanged after TypeScript type fixes in PR-D6D336C1
    Given the DriverCell API response schema recorded before PR-D6D336C1
    When the DriverCell API is called after the PR change
    Then all previously existing response fields are present with the same types

  @regression @api
  Scenario: LocationCell returns a formatted address for a valid GPS coordinate in a logon record
    Given a driver logon record with coordinates latitude "-36.8485" and longitude "174.7633"
    When the LocationCell data is retrieved
    Then the response contains a human-readable address for Auckland, NZ

  @negative @api
  Scenario: LocationCell returns a placeholder when the logon record has no GPS data
    Given a driver logon record with null latitude and null longitude
    When the LocationCell data is requested
    Then the response location field is null or empty string
      And no geocoding error propagates to the caller

  @boundary @api
  Scenario: LocationCell handles coordinates at the extreme valid boundary of -90 latitude and -180 longitude
    Given a driver logon record with latitude "-90" and longitude "-180"
    When the LocationCell data is retrieved
    Then the response is returned without a validation error

  @happy @api
  Scenario: LocationCell returns both raw coordinates and a formatted address string
    Given an authenticated request for a logon record with valid GPS data
    When the LocationCell API endpoint is called
    Then the response contains latitude, longitude, and a formattedAddress field

  @alt @api
  Scenario: LocationCell returns raw coordinates when reverse geocoding is disabled in fleet settings
    Given a fleet with reverse geocoding disabled
      And a driver logon record with valid GPS coordinates
    When the LocationCell data is retrieved
    Then the response contains only latitude and longitude without a formattedAddress

  @auth @api
  Scenario: LocationCell API returns 401 when called with an expired token
    Given an expired authentication token
    When the LocationCell API is called
    Then the response status is 401
      And the body indicates the token has expired

  @error @api
  Scenario: LocationCell API returns a graceful error when the geocoding provider returns an unexpected response
    Given the geocoding provider returns an invalid non-JSON response
    When the LocationCell data is retrieved for a valid logon record
    Then the API returns a 502 status
      And the error message references a geocoding provider failure

  @compat @api
  Scenario: LocationCell API response fields and types remain stable after PR-D6D336C1 type fixes
    Given the LocationCell API response schema recorded before PR-D6D336C1
    When the LocationCell API is called after the change
    Then the response schema has no removed or renamed fields

  @regression @api
  Scenario: StatusCell returns "LOGGED_ON" status for an active driver session
    Given a driver with an active dashcam logon session
    When the StatusCell data is retrieved for that session
    Then the status field equals "LOGGED_ON"

  @negative @api
  Scenario: StatusCell returns an appropriate value when an unrecognised status code is present in the record
    Given a driver logon record containing an unrecognised status code "UNKNOWN_STATE"
    When the StatusCell data is retrieved
    Then the response does not throw a 500 error
      And the status field is returned as "UNKNOWN" or null

  @boundary @api
  Scenario: StatusCell handles a status string at exactly the maximum allowed character length
    Given a logon record with a status value of exactly 64 characters
    When the StatusCell data is retrieved
    Then the full status string is returned without truncation or error

  @happy @api
  Scenario: StatusCell returns a status object containing the status code and a display label
    Given an authenticated request for a logon record with status "LOGGED_OFF"
    When the StatusCell API is called
    Then the response contains statusCode "LOGGED_OFF" and a non-empty displayLabel

  @alt @api
  Scenario: StatusCell returns "IN_PROGRESS" when a driver logon is partially completed
    Given a driver logon event that has been initiated but not yet confirmed
    When the StatusCell data is retrieved
    Then the status field equals "IN_PROGRESS"

  @auth @api
  Scenario: StatusCell returns 403 when the requesting user does not have dashcam status view permission
    Given a user without "dashcam.status.view" permission
    When the StatusCell API is called for a logon record
    Then the response status is 403

  @error @api
  Scenario: StatusCell API returns a 500 error with a structured error body when the status lookup fails internally
    Given the internal status lookup service throws an unhandled exception
    When the StatusCell API is called for a valid logon record
    Then the response status is 500
      And the error body contains a correlationId field

  @compat @api
  Scenario: StatusCell API status codes remain consistent with pre-PR-D6D336C1 enum values
    Given the set of valid status codes documented before PR-D6D336C1
    When the StatusCell API is called for records with each status type
    Then all returned status codes match the pre-change enumeration values

  @regression @api
  Scenario: DataRetention returns the current retention period for a valid fleet
    Given an authenticated fleet admin
    When the data retention settings are retrieved for the fleet
    Then the response contains a retentionPeriodDays integer greater than zero

  @negative @api
  Scenario: DataRetention returns 404 when the fleet ID does not exist
    Given a fleet ID "fleet-nonexistent-999"
    When the data retention settings are requested for that fleet
    Then the response status is 404
      And the error body references the unknown fleet ID

  @boundary @api
  Scenario: DataRetention accepts a retention period of exactly 1 day as the minimum valid value
    Given an authenticated fleet admin
    When the data retention period is set to 1 day
    Then the API accepts the value with a 200 response
      And the stored retentionPeriodDays equals 1

  @happy @api
  Scenario: DataRetention returns retention settings including period, unit, and last-modified timestamp
    Given an authenticated fleet admin for a fleet with configured data retention
    When the data retention settings endpoint is called
    Then the response includes retentionPeriodDays, unit, and lastModifiedAt fields

  @alt @api
  Scenario: DataRetention returns the default retention period when no custom period has been configured
    Given a newly created fleet with no custom retention setting
    When the data retention settings are retrieved
    Then the retentionPeriodDays equals the system default value

  @auth @api
  Scenario: DataRetention returns 403 when called by a user who is not a fleet admin
    Given a user with a driver-only role
    When the data retention settings endpoint is called
    Then the response status is 403

  @error @api
  Scenario: DataRetention API returns 500 with a structured error when the persistence layer is unavailable
    Given the data retention persistence layer is offline
    When the data retention settings are retrieved by an admin
    Then the response status is 500
      And the error body contains a meaningful message and correlationId

  @compat @api
  Scenario: DataRetention API response schema is unchanged after PR-D6D336C1 type refactor
    Given the DataRetention API response schema captured before PR-D6D336C1
    When the endpoint is called after the change
    Then all previously present fields remain with unchanged types

  @regression @api
  Scenario: DataRetentionPeriodUpdateModal successfully updates the retention period via the API
    Given an authenticated fleet admin
      And the current retention period is 30 days
    When a PATCH request is submitted with retentionPeriodDays set to 60
    Then the response status is 200
      And the stored retention period is updated to 60 days

  @negative @api
  Scenario: DataRetentionPeriodUpdateModal API rejects a negative retention period value
    Given an authenticated fleet admin
    When a PATCH request is submitted with retentionPeriodDays set to -1
    Then the response status is 422
      And the error body indicates retentionPeriodDays must be a positive integer

  @boundary @api
  Scenario: DataRetentionPeriodUpdateModal API rejects a retention period exceeding the maximum allowed value
    Given the maximum allowed retention period is 365 days
    When a PATCH request is submitted with retentionPeriodDays set to 366
    Then the response status is 422
      And the error body references the maximum allowed value

  @happy @api
  Scenario: DataRetentionPeriodUpdateModal API returns the updated retention object after a successful update
    Given an authenticated fleet admin
    When a PATCH request is submitted with retentionPeriodDays set to 90
    Then the response body contains the updated retentionPeriodDays value of 90
      And the lastModifiedAt timestamp is updated

  @alt @api
  Scenario: DataRetentionPeriodUpdateModal API is idempotent when the same period is submitted twice
    Given an authenticated fleet admin with current retention period of 45 days
    When two identical PATCH requests with retentionPeriodDays set to 45 are submitted sequentially
    Then both responses return 200
      And the final stored retention period is 45 days

  @auth @api
  Scenario: DataRetentionPeriodUpdateModal API returns 401 when the request has no authentication token
    Given the data retention update endpoint
    When a PATCH request is submitted without an auth token
    Then the response status is 401

  @error @api
  Scenario: DataRetentionPeriodUpdateModal API returns 409 when a concurrent update is detected
    Given two simultaneous PATCH requests for the same fleet's retention period
    When both requests arrive at the server concurrently
    Then one request succeeds with 200
      And the other request returns 409 with a conflict error message

  @compat @api
  Scenario: DataRetentionPeriodUpdateModal PATCH request and response body schema are unchanged after PR-D6D336C1
    Given the PATCH request and response schema for DataRetentionPeriodUpdateModal before PR-D6D336C1
    When the endpoint is called after the change with the same request body
    Then the response schema matches the pre-change contract

  @regression @api
  Scenario: OfflineNotifications returns a list of offline notification events for a valid vehicle
    Given a vehicle with ID "VEH-001" that has had offline events
    When the offline notifications API is called for "VEH-001"
    Then the response contains at least one notification with a timestamp and reason

  @negative @api
  Scenario: OfflineNotifications returns an empty list when no offline events exist for the vehicle
    Given a vehicle "VEH-NEW" with no offline history
    When the offline notifications API is called for "VEH-NEW"
    Then the response status is 200
      And the notifications array is empty

  @boundary @api
  Scenario: OfflineNotifications returns the maximum page size when a vehicle has more notifications than the page limit
    Given a vehicle with 1000 offline notification events
    When the offline notifications API is called with default pagination
    Then the response contains exactly the configured page-size limit of notifications
      And a nextPageToken is present in the response

  @happy @api
  Scenario: OfflineNotifications returns notifications with vehicleId, timestamp, reason, and duration fields
    Given a vehicle with recorded offline events
    When the offline notifications API is called with valid authentication
    Then each notification contains vehicleId, timestamp, reason, and durationSeconds fields

  @alt @api
  Scenario: OfflineNotifications returns notifications filtered by date range when from and to query parameters are provided
    Given a vehicle with offline events spread across multiple months
    When the offline notifications API is called with from "2024-01-01" and to "2024-01-31"
    Then all returned notifications have timestamps within January 2024

  @auth @api
  Scenario: OfflineNotifications returns 403 when the user does not have access to the requested vehicle's fleet
    Given a user who belongs to fleet "A" requesting notifications for a vehicle in fleet "B"
    When the offline notifications API is called
    Then the response status is 403

  @error @api
  Scenario: OfflineNotifications returns 502 when the notification aggregation service is unreachable
    Given the notification aggregation service is unreachable
    When the offline notifications API is called for a valid vehicle
    Then the response status is 502
      And the error body references a downstream service failure

  @compat @api
  Scenario: OfflineNotifications API response fields are unchanged after PR-D6D336C1 type refactor
    Given the OfflineNotifications API response schema before PR-D6D336C1
    When the API is called after the change
    Then no fields have been removed or had their type changed

  @regression @ui
  Scenario: Dashcam API module loads driver logon data and populates the UI table
    Given the user is logged in and navigates to the Dashcam section
    When the page loads and the API module fetches driver logon data
    Then the driver logon table is populated with at least one row
      And no network errors appear in the browser console

  @negative @ui
  Scenario: Dashcam API module displays an error banner when the server returns a 500 response
    Given the dashcam API returns a 500 error for the logon data request
    When the user navigates to the Dashcam section
    Then an error banner is displayed informing the user of a server error
      And the table does not render with empty or corrupted data

  @boundary @ui
  Scenario: Dashcam API module correctly handles a paginated response at the last page with zero items
    Given the dashcam API returns an empty items array with totalCount equal to the already-loaded count
    When the user navigates to the last page of the driver logon table
    Then no additional rows are rendered
      And the pagination control indicates the last page has been reached

  @happy @ui
  Scenario: Dashcam API module fetches and displays the correct number of driver logon records
    Given 25 driver logon records exist for the fleet
    When the user opens the Dashcam driver logon view
    Then 25 rows are displayed in the table
      And each row includes a formatted date, driver name, location, and status

  @alt @ui
  Scenario: Dashcam API module retries the request automatically after a transient 503 response
    Given the dashcam API returns 503 on the first request and 200 on the second
    When the Dashcam section loads
    Then the UI retries the request
      And the table is eventually populated with driver logon data

  @auth @ui
  Scenario: Dashcam API module redirects the user to the login page when the session token has expired
    Given the user's session token has expired
    When the Dashcam API module makes a data request
    Then the user is redirected to the login page
      And a session-expired message is displayed

  @error @ui
  Scenario: Dashcam API module shows a user-friendly message when the network request times out
    Given the dashcam API call exceeds the configured request timeout
    When the Dashcam section loads
    Then a timeout error message is shown to the user
      And the table skeleton loader is replaced with the error state

  @compat @ui
  Scenario: Dashcam API module request and response handling are unchanged after the TSFixMe removal in PR-D6D336C1
    Given the API request payloads and response parsing logic before PR-D6D336C1
    When the same API endpoints are exercised after the change
    Then request payloads and parsed responses are structurally identical

  @regression @api
  Scenario: SettingsToggle returns the current enabled state for a valid dashcam setting
    Given a fleet with the "offline-notifications" setting enabled
    When the settings toggle API is called for "offline-notifications"
    Then the response contains enabled true

  @negative @api
  Scenario: SettingsToggle returns 404 when an unrecognised setting key is requested
    Given a settings toggle API call for key "non-existent-setting"
    When the request is made with valid authentication
    Then the response status is 404
      And the error body references the unknown setting key

  @boundary @api
  Scenario: SettingsToggle handles a setting key at the maximum allowed key length without error
    Given a setting key that is exactly 128 characters long and exists in the system
    When the settings toggle API is called for that key
    Then the response returns the setting state with a 200 status

  @happy @api
  Scenario: SettingsToggle successfully toggles a setting from disabled to enabled
    Given the "data-retention-alerts" setting is currently disabled for a fleet
    When the settings toggle API is called with enabled set to true
    Then the response status is 200
      And the stored setting state is enabled

  @alt @api
  Scenario: SettingsToggle returns the same state when toggled to its current value
    Given the "offline-notifications" setting is already enabled
    When the settings toggle API is called with enabled set to true
    Then the response status is 200
      And the setting remains enabled without triggering a change event

  @auth @api
  Scenario: SettingsToggle returns 403 when a non-admin user attempts to change a setting
    Given a user with a read-only role
    When the settings toggle API is called with a new enabled value
    Then the response status is 403
      And the error message references insufficient privileges

  @error @api
  Scenario: SettingsToggle API returns 500 when the settings persistence service is unavailable
    Given the settings persistence service is offline
    When the settings toggle API is called with valid authentication and a known key
    Then the response status is 500
      And the error body contains a correlationId

  @compat @api
  Scenario: SettingsToggle API request body and response schema are unchanged after PR-D6D336C1
    Given the SettingsToggle API schema captured before PR-D6D336C1
    When the API is called with an equivalent request after the change
    Then the response schema matches the pre-change contract with no removed or renamed fields

  @regression @api
  Scenario: types module exports all expected Dashcam domain type definitions after the TSFixMe removal
    Given the updated types module from PR-D6D336C1
    When the exported type names are inspected at build time
    Then DriverLogonRecord, DataRetentionSettings, OfflineNotification, and SettingToggleState are all exported

  @negative @api
  Scenario: types module prevents assignment of null to a field typed as non-nullable after TSFixMe removal
    Given the updated types module enforcing strict nullability on DriverLogonRecord.driverId
    When a DriverLogonRecord is constructed with driverId set to null at compile time
    Then a TypeScript compilation error is raised for the null assignment

  @boundary @api
  Scenario: types module correctly defines an enum with both minimum and maximum allowed status values
    Given the DriverLogonStatus enum in the types module
    When the full set of enum members is inspected
    Then the enum contains at least a minimum active status and a maximum terminal status with no undefined members

  @happy @api
  Scenario: types module provides correct type definitions that allow the API layer to compile without errors
    Given the types module from PR-D6D336C1 is imported into the API layer
    When the dashcam API module is compiled with strict TypeScript settings
    Then the compilation produces zero type errors

  @alt @api
  Scenario: types module union types correctly narrow to the specific variant when discriminated by a status field
    Given a value typed as the DriverLogonEvent discriminated union
    When the value is narrowed by checking the status field
    Then the TypeScript compiler infers the correct concrete type for that variant

  @auth @api
  Scenario: types module does not expose any fields that would leak internal authentication tokens or secrets
    Given the exported types in the Dashcam domain types module
    When each exported interface and type alias is reviewed for sensitive field names
    Then no field names such as token, secret, password, or apiKey are present in any exported type

  @error @api
  Scenario: types module defines an error response type that includes both a message and a correlationId field
    Given the DashcamApiError type in the types module
    When the type definition is inspected
    Then it includes a required message field of type string and a required correlationId field of type string

  @compat @api
  Scenario: types module does not introduce breaking changes to existing type contracts consumed by other modules
    Given the set of type definitions exported before PR-D6D336C1
    When the updated types module is imported by all consumer modules
    Then no consumer module introduces new compilation errors due to removed or incompatible type definitions

