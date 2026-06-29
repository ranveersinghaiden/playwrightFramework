Feature: Tests for PR: PR-D6D336C1

  @regression @api
  Scenario: DriverLogonCardTableColumnDefinitions renders all expected columns after type-safe refactor
    Given the dashcam driver logon card table column definitions are loaded
    When the column definitions are evaluated
    Then columns for DateTime, Driver, Location, and Status are all present with correct keys and render functions

  @negative @api
  Scenario: DriverLogonCardTableColumnDefinitions handles missing column configuration gracefully
    Given a column definition entry is provided without a required field accessor
    When the table attempts to render that column
    Then no uncaught type error is thrown and the cell renders an empty placeholder

  @boundary @api
  Scenario: DriverLogonCardTableColumnDefinitions operates correctly with zero and maximum column sets
    Given the column definitions array is empty
    When the table column renderer is invoked
    Then no columns are rendered and no runtime error occurs
      And when all supported columns are included the table renders without overflow or truncation

  @happy @api
  Scenario: DriverLogonCardTableColumnDefinitions returns correctly typed column definition objects
    Given a complete set of driver logon column definition inputs is provided
    When the column definitions factory is called
    Then each returned object conforms to the strongly-typed ColumnDefinition interface with no any-typed fields

  @alt @api
  Scenario: DriverLogonCardTableColumnDefinitions supports custom column ordering
    Given column definitions are provided in non-default order
    When the driver logon card table is rendered
    Then columns appear in the specified order without type coercion errors

  @auth @api
  Scenario: DriverLogonCardTableColumnDefinitions does not expose column data to unauthenticated callers
    Given the requesting user has no valid session token
    When the column definitions endpoint is accessed
    Then a 401 Unauthorized response is returned and no column metadata is included

  @error @api
  Scenario: DriverLogonCardTableColumnDefinitions returns a structured error when the column config service fails
    Given the column configuration service throws an internal error
    When the column definitions are requested
    Then a 500 response with an error payload is returned and no partial column data is leaked

  @compat @api
  Scenario: DriverLogonCardTableColumnDefinitions response schema is unchanged from previous release
    Given a client built against the previous column definitions contract
    When it requests driver logon card table column definitions
    Then the response fields and types are backward compatible with the prior version

  @regression @ui
  Scenario: DateTimeLogonCell renders date and time correctly after $TSFixMe removal
    Given a driver logon record with a valid ISO 8601 timestamp
    When the DateTimeLogonCell component is rendered in the driver logon table
    Then the formatted date and time string is displayed without any rendering regression

  @negative @ui
  Scenario: DateTimeLogonCell renders a dash when timestamp value is null
    Given a driver logon record where the timestamp field is null
    When the DateTimeLogonCell component is rendered
    Then a dash or empty placeholder is shown and no JavaScript console error is raised

  @boundary @api
  Scenario: DateTimeLogonCell handles epoch zero and far-future timestamps
    Given a timestamp of Unix epoch zero "1970-01-01T00:00:00Z"
      And a timestamp of "2099-12-31T23:59:59Z"
    When each is passed to the DateTimeLogonCell renderer
    Then both timestamps are formatted correctly without overflow or type coercion failure

  @happy @ui
  Scenario: DateTimeLogonCell displays date and time in the organisation timezone
    Given the organisation timezone is set to "Pacific/Auckland"
      And a driver logon record with a valid UTC timestamp
    When the DateTimeLogonCell component is mounted
    Then the displayed time reflects the Auckland local time

  @alt @ui
  Scenario: DateTimeLogonCell displays date and time in UTC when no organisation timezone is configured
    Given no organisation timezone is configured
      And a driver logon record with a valid UTC timestamp
    When the DateTimeLogonCell component is rendered
    Then the time is displayed in UTC format

  @auth @api
  Scenario: DateTimeLogonCell data is not returned to callers without a valid session
    Given the request to fetch driver logon records lacks an authorisation token
    When the API endpoint backing DateTimeLogonCell is called
    Then a 401 Unauthorized response is returned

  @error @ui
  Scenario: DateTimeLogonCell renders an error state when the timestamp format is unrecognised
    Given a driver logon record with a malformed timestamp "not-a-date"
    When the DateTimeLogonCell component processes the value
    Then a fallback indicator is shown and no unhandled exception propagates to the parent component

  @compat @api
  Scenario: DateTimeLogonCell timestamp API field remains present in the response after the type refactor
    Given a consumer relying on the legacy timestamp field name in the logon record API response
    When the logon records endpoint is called
    Then the timestamp field is present and correctly typed in the response payload

  @regression @api
  Scenario: DriverCell returns driver display name without $TSFixMe casting after refactor
    Given a driver logon record with a fully populated driver object
    When the DriverCell renderer is invoked
    Then the driver's full name is returned as a strongly-typed string without any-cast intermediaries

  @negative @api
  Scenario: DriverCell handles a logon record with no associated driver
    Given a driver logon record where the driver field is undefined
    When the DriverCell renderer is invoked
    Then an empty string or dash placeholder is returned and no type error is thrown

  @boundary @api
  Scenario: DriverCell handles a driver name at the maximum allowed character length
    Given a driver with a name exactly 255 characters long
    When the DriverCell renderer processes the record
    Then the full name is returned without truncation or error

  @happy @api
  Scenario: DriverCell returns correctly typed driver name for a standard logon record
    Given a driver logon record with a valid driver name "Jane Smith"
    When the DriverCell renderer is called with that record
    Then the string "Jane Smith" is returned with the correct TypeScript type

  @alt @api
  Scenario: DriverCell displays driver ID when driver name is absent but ID is present
    Given a driver logon record where the driver name is null but the driver ID is set
    When the DriverCell renderer is invoked
    Then the driver ID is used as the display value

  @auth @api
  Scenario: DriverCell endpoint rejects requests from users without dashcam read permission
    Given a user with no dashcam data read entitlement
    When the user requests driver logon data containing DriverCell fields
    Then a 403 Forbidden response is returned

  @error @api
  Scenario: DriverCell handles a downstream driver-profile service failure gracefully
    Given the driver profile service returns a 503 error for the requested driver
    When the DriverCell renderer attempts to resolve the driver details
    Then a fallback placeholder is shown and the error is captured in the application error boundary

  @compat @api
  Scenario: DriverCell driver object schema is unchanged from the previous release
    Given a client that maps the driver logon API response using the previous field names
    When the logon records API is called after the type refactor
    Then the driver object fields match the prior schema so the client mapping remains valid

  @regression @api
  Scenario: LocationCell returns location string without any-typed intermediate after type refactor
    Given a driver logon record with a populated location object
    When the LocationCell renderer is invoked
    Then the location is returned as a strongly-typed string with no $TSFixMe bypass

  @negative @api
  Scenario: LocationCell renders a placeholder when latitude and longitude are both null
    Given a driver logon record with latitude null and longitude null
    When the LocationCell renderer is invoked
    Then a dash placeholder is returned and no TypeError is thrown

  @boundary @api
  Scenario: LocationCell handles extreme coordinate boundary values
    Given a location with latitude -90 and longitude -180
      And a location with latitude 90 and longitude 180
    When both are passed to the LocationCell renderer
    Then each returns a valid formatted string without numeric overflow

  @happy @api
  Scenario: LocationCell formats a valid coordinate pair into a human-readable address
    Given a driver logon record with latitude -36.8485 and longitude 174.7633
    When the LocationCell renderer is invoked
    Then the returned string represents the Auckland location in the expected display format

  @alt @api
  Scenario: LocationCell displays a raw coordinate string when reverse-geocoding is unavailable
    Given the reverse-geocoding service is disabled
      And a driver logon record with valid coordinates
    When the LocationCell renderer is invoked
    Then the coordinates are displayed in decimal-degree format as a fallback

  @auth @api
  Scenario: LocationCell data is withheld from unauthenticated requests
    Given a request to the driver logon endpoint without an authentication token
    When the endpoint is called
    Then the response does not include location data and a 401 status is returned

  @error @api
  Scenario: LocationCell returns an error indicator when the geocoding service throws an exception
    Given the geocoding service throws a runtime exception for the requested coordinates
    When the LocationCell renderer attempts to resolve the address
    Then an error indicator is shown and the exception is logged without crashing the parent component

  @compat @api
  Scenario: LocationCell location field names in the API response are unchanged after the refactor
    Given a legacy client mapping the location object by its previous field names
    When the logon records API is called
    Then the location field names match the prior contract so the legacy client continues to function

  @regression @api
  Scenario: StatusCell returns a typed status value after $TSFixMe removal
    Given a driver logon record with status "ONLINE"
    When the StatusCell renderer is invoked after the type refactor
    Then the status is returned as the strongly-typed DashcamStatus enum value with no any-cast

  @negative @api
  Scenario: StatusCell handles an unrecognised status string without crashing
    Given a driver logon record with status "UNKNOWN_STATUS_CODE"
    When the StatusCell renderer is invoked
    Then a default fallback status is displayed and no unhandled exception is raised

  @boundary @api
  Scenario: StatusCell renders correctly for all defined DashcamStatus enum values
    Given each value in the DashcamStatus enum is used in a separate logon record
    When the StatusCell renderer processes each record
    Then each enum value maps to the correct display label and colour without error

  @happy @api
  Scenario: StatusCell displays ONLINE status with the correct indicator for an active dashcam
    Given a driver logon record where the dashcam status is "ONLINE"
    When the StatusCell is rendered
    Then the status indicator shows green and the label reads "Online"

  @alt @api
  Scenario: StatusCell displays OFFLINE status when the dashcam has not reported within the expected interval
    Given a driver logon record where the dashcam status is "OFFLINE"
    When the StatusCell is rendered
    Then the status indicator shows the offline colour and the label reads "Offline"

  @auth @api
  Scenario: StatusCell data endpoint returns 401 when the caller is unauthenticated
    Given a request to retrieve dashcam status data without a valid bearer token
    When the status endpoint is called
    Then a 401 Unauthorized response is returned and no status data is disclosed

  @error @api
  Scenario: StatusCell renders an error state when the status service is unavailable
    Given the dashcam status service returns a 503 response
    When the StatusCell renderer attempts to retrieve the status
    Then an error indicator is displayed and the failure is reported in the application logs

  @compat @api
  Scenario: StatusCell status field values in the API response remain backward compatible
    Given a client application that expects the status field to use the previous string values
    When the logon records API is called after the refactor
    Then the status string values in the response are unchanged from the prior release

  @regression @api
  Scenario: DataRetention settings load correctly after TypeScript type refactor
    Given a valid organisation with dashcam data retention settings configured
    When the DataRetention settings are fetched from the API
    Then the retention period is returned as a strongly-typed number with no $TSFixMe workarounds

  @negative @api
  Scenario: DataRetention rejects a retention period update with a negative value
    Given an administrator submits a retention period update with value -1
    When the DataRetention API processes the request
    Then a 400 Bad Request response is returned with a validation error message

  @boundary @api
  Scenario: DataRetention accepts the minimum and maximum allowed retention period values
    Given the minimum allowed retention period is 1 day
      And the maximum allowed retention period is 365 days
    When update requests are submitted for each boundary value
    Then both values are accepted and persisted without validation errors

  @happy @api
  Scenario: DataRetention returns current retention period for a configured organisation
    Given an organisation has a dashcam data retention period of 30 days
    When the DataRetention settings endpoint is called
    Then the response includes retentionPeriodDays equal to 30

  @alt @api
  Scenario: DataRetention returns a default retention period when none has been explicitly configured
    Given an organisation has never configured a dashcam data retention period
    When the DataRetention settings endpoint is called
    Then the response returns the system default retention period

  @auth @api
  Scenario: DataRetention endpoint returns 403 when accessed by a non-admin user
    Given a standard user without administration privileges
    When the user calls the DataRetention settings endpoint
    Then a 403 Forbidden response is returned

  @error @api
  Scenario: DataRetention endpoint returns 500 with a safe error payload when the database is unavailable
    Given the database backing the data retention settings is unreachable
    When the DataRetention endpoint is called
    Then a 500 response is returned with a generic error message and no stack trace is exposed

  @compat @api
  Scenario: DataRetention API response schema is unchanged from the previous version
    Given a client using the previous DataRetention API response contract
    When the DataRetention endpoint is called after the refactor
    Then the field names and types in the response match the prior schema

  @regression @api
  Scenario: DataRetentionPeriodUpdateModal submits a valid period without type casting errors
    Given an admin has the DataRetentionPeriodUpdateModal open with current period 30 days
    When the admin changes the period to 60 days and confirms the update
    Then the API receives a correctly typed payload and returns 200 with the updated period

  @negative @api
  Scenario: DataRetentionPeriodUpdateModal rejects non-numeric input in the period field
    Given the admin enters "abc" in the retention period input field
    When the admin attempts to submit the modal
    Then a validation error is displayed and no API call is made

  @boundary @api
  Scenario: DataRetentionPeriodUpdateModal enforces the minimum period of 1 day
    Given the admin enters 0 in the retention period field
    When the admin attempts to submit the modal
    Then a validation error states the minimum period is 1 day and the form is not submitted

  @happy @api
  Scenario: DataRetentionPeriodUpdateModal successfully updates the retention period to a valid value
    Given an admin opens the DataRetentionPeriodUpdateModal
    When the admin sets the period to 90 days and submits
    Then the retention period is updated to 90 days and a success notification is shown

  @alt @api
  Scenario: DataRetentionPeriodUpdateModal cancels the update without persisting changes
    Given an admin opens the DataRetentionPeriodUpdateModal and changes the period to 180 days
    When the admin clicks Cancel
    Then no API call is made and the existing retention period remains unchanged

  @auth @api
  Scenario: DataRetentionPeriodUpdateModal update request is rejected for non-admin callers
    Given a non-admin user submits a period update request to the modal's backing API
    When the request is processed
    Then a 403 Forbidden response is returned and the retention period is not modified

  @error @api
  Scenario: DataRetentionPeriodUpdateModal displays an error notification when the update API call fails
    Given the DataRetention update API returns a 500 error
    When the admin submits the modal
    Then an error notification is displayed to the admin and the modal remains open for retry

  @compat @api
  Scenario: DataRetentionPeriodUpdateModal update payload schema is unchanged from the previous release
    Given a client sending the retention period update payload using the previous field names
    When the update endpoint is called after the refactor
    Then the payload is accepted and the period is updated correctly

  @regression @api
  Scenario: OfflineNotifications are dispatched correctly after type-safe refactor
    Given a dashcam device transitions to OFFLINE status
    When the OfflineNotifications service processes the status change event
    Then a typed notification payload is dispatched without any $TSFixMe-related runtime errors

  @negative @api
  Scenario: OfflineNotifications does not dispatch when the device status is not OFFLINE
    Given a dashcam device has status "ONLINE"
    When the OfflineNotifications service evaluates the device state
    Then no offline notification is triggered

  @boundary @api
  Scenario: OfflineNotifications handles the threshold boundary for offline detection
    Given the offline detection threshold is 5 minutes
      And a dashcam device has been unreachable for exactly 5 minutes
    When the OfflineNotifications service runs its evaluation
    Then an offline notification is dispatched at the exact threshold without off-by-one error

  @happy @api
  Scenario: OfflineNotifications sends a notification to the correct recipient when a dashcam goes offline
    Given a dashcam device with ID "CAM-001" transitions to OFFLINE
      And the device is assigned to fleet manager "manager@example.com"
    When the OfflineNotifications service processes the event
    Then a notification is sent to "manager@example.com" containing the device ID "CAM-001"

  @alt @api
  Scenario: OfflineNotifications suppresses duplicate notifications within the cooldown window
    Given a dashcam device has already triggered an offline notification
    When the same device remains OFFLINE and the evaluation runs again within the cooldown window
    Then no duplicate notification is dispatched

  @auth @api
  Scenario: OfflineNotifications API endpoint returns 401 for unauthenticated subscription requests
    Given an unauthenticated caller attempts to subscribe to offline notifications
    When the subscription endpoint is called
    Then a 401 Unauthorized response is returned and no subscription is created

  @error @api
  Scenario: OfflineNotifications captures and logs failures when the notification delivery service is unavailable
    Given the notification delivery service is down
    When the OfflineNotifications service attempts to dispatch an offline event
    Then the failure is logged with the device ID and a retry is scheduled without crashing the service

  @compat @api
  Scenario: OfflineNotifications webhook payload schema is unchanged from the previous release
    Given a subscriber consuming offline notification webhooks using the previous payload schema
    When an offline notification is dispatched after the refactor
    Then the webhook payload fields and types match the prior schema

  @regression @api
  Scenario: Dashcam API returns strongly-typed responses after $TSFixMe removal
    Given valid credentials and a configured dashcam device
    When the dashcam API is called to retrieve device data
    Then the response fields conform to the updated TypeScript types with no regression in the returned data structure

  @negative @api
  Scenario: Dashcam API returns 400 when a required request parameter is missing
    Given an API request to the dashcam endpoint is sent without the required deviceId parameter
    When the request is processed
    Then a 400 Bad Request response is returned with a descriptive error indicating the missing parameter

  @boundary @api
  Scenario: Dashcam API handles pagination at the first and last page boundaries
    Given there are exactly 50 dashcam records and the page size is 25
    When page 1 and page 2 are requested separately
    Then each page returns 25 records and page 3 returns an empty list without error

  @happy @ui
  Scenario: Dashcam API integration displays dashcam list in the UI for a standard fleet
    Given I am logged in as a fleet manager with at least one active dashcam
    When I navigate to the dashcam management page
    Then the dashcam list is populated with data from the API and each row renders without error

  @alt @ui
  Scenario: Dashcam API integration shows an empty state in the UI when no dashcams are assigned
    Given I am logged in as a fleet manager with no dashcams assigned
    When I navigate to the dashcam management page
    Then an empty-state message is displayed instead of the data table

  @auth @api
  Scenario: Dashcam API returns 401 when the bearer token is expired
    Given the caller uses an expired JWT bearer token
    When any dashcam API endpoint is called
    Then a 401 Unauthorized response is returned with a token-expired error code

  @error @api
  Scenario: Dashcam API returns a safe 500 error when the backend data store is unreachable
    Given the dashcam data store is unavailable
    When the dashcam list endpoint is called
    Then a 500 response is returned with a generic error message and no internal stack trace is exposed

  @compat @api
  Scenario: Dashcam API v1 endpoints remain available and return the expected schema after the refactor
    Given a client application integrated against the dashcam API v1 contract
    When v1 endpoints are called after the TypeScript type refactor is deployed
    Then the response schema is identical to the prior version and the client continues to function

  @regression @api
  Scenario: SettingsToggle persists the correct typed boolean value after the refactor
    Given a dashcam settings toggle for "OfflineAlerts" is currently enabled
    When the toggle state is read from the API after the TypeScript type refactor
    Then the value is returned as a boolean true with no any-type coercion

  @negative @api
  Scenario: SettingsToggle rejects an update request with a non-boolean value
    Given a caller sends a toggle update request with the value "yes" instead of true
    When the SettingsToggle API processes the request
    Then a 400 Bad Request response is returned indicating the value must be a boolean

  @boundary @api
  Scenario: SettingsToggle correctly handles toggling from enabled to disabled and back
    Given a SettingsToggle for "OfflineAlerts" is enabled
    When it is toggled off and then immediately toggled on again
    Then the final state is enabled and exactly two state-change events are recorded

  @happy @api
  Scenario: SettingsToggle enables an offline alert setting for a dashcam device
    Given a dashcam settings page with the OfflineAlerts toggle currently off
    When an admin enables the OfflineAlerts toggle via the API
    Then the toggle state is persisted as true and a confirmation response is returned

  @alt @api
  Scenario: SettingsToggle disables a previously enabled setting without side effects
    Given the OfflineAlerts toggle is currently enabled for a dashcam device
    When an admin disables the toggle via the API
    Then the toggle state is persisted as false and no offline notification is sent for subsequent offline events

  @auth @api
  Scenario: SettingsToggle update endpoint returns 403 for users without settings-write permission
    Given a user with read-only fleet permissions
    When the user sends a toggle update request
    Then a 403 Forbidden response is returned and the toggle state remains unchanged

  @error @api
  Scenario: SettingsToggle returns a 500 error and logs the failure when the settings store is unavailable
    Given the settings data store is unreachable
    When an admin attempts to update a SettingsToggle value
    Then a 500 response is returned with a safe error message and the failure is logged with the toggle name

  @compat @api
  Scenario: SettingsToggle API request and response schema is unchanged from the previous version
    Given a client using the previous SettingsToggle API contract with boolean field names
    When the toggle endpoint is called after the refactor
    Then the request and response field names and types match the prior schema

  @regression @api
  Scenario: Dashcam domain types enforce correct structure after $TSFixMe removal
    Given the dashcam API returns a device record
    When the record is deserialized into the updated dashcam domain types
    Then all required fields are present and no field falls back to an any type

  @negative @api
  Scenario: Dashcam domain types reject payloads missing required fields at the API boundary
    Given a dashcam device payload that omits the required deviceId field
    When the payload is submitted to the dashcam API
    Then a 400 Bad Request is returned indicating the missing field according to the type contract

  @boundary @api
  Scenario: Dashcam domain types handle string fields at the maximum allowed length boundary
    Given a dashcam device name exactly at the 200-character maximum
    When the device record is submitted to the API
    Then the record is accepted and the full name is stored without truncation

  @happy @api
  Scenario: Dashcam domain types correctly model a fully populated DashcamDevice record
    Given all optional and required fields of the DashcamDevice type are populated with valid values
    When the device record is submitted to and retrieved from the API
    Then the retrieved record matches the submitted values across all typed fields

  @alt @api
  Scenario: Dashcam domain types handle optional fields being absent without runtime errors
    Given a DashcamDevice record where all optional fields are omitted
    When the record is submitted to and retrieved from the API
    Then the required fields are present and all optional fields are absent or null without error

  @auth @api
  Scenario: Dashcam type schema endpoint requires authentication to retrieve the API type definitions
    Given an unauthenticated caller requests the dashcam type schema documentation endpoint
    When the request is processed
    Then a 401 Unauthorized response is returned

  @error @api
  Scenario: Dashcam domain types surface a clear error when an enum field receives an out-of-range value
    Given a dashcam status field is set to a value not defined in the DashcamStatus enum
    When the payload is processed by the API
    Then a 422 Unprocessable Entity response is returned identifying the invalid enum value

  @compat @api
  Scenario: Dashcam domain type field names and shapes are unchanged from the prior release
    Given a client application serialising and deserialising dashcam payloads using the previous type definitions
    When the same payloads are exchanged with the API after the type refactor
    Then all field names, types, and optionality match the prior contract so the client requires no changes

