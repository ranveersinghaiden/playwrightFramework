Feature: Tests for PR: PR-D6D336C1

  @api @smoke
  Scenario: DriverLogonCardTableColumnDefinitions returns all four typed column definitions
    Given the DriverLogonCardTableColumnDefinitions factory is invoked
    When the column definitions are retrieved
    Then the response contains exactly four columns: "DateTime", "Driver", "Location", "Status"
      And each column definition has a strictly-typed "field", "header", and "renderCell" property

  @api @regression
  Scenario: DriverLogonCardTableColumnDefinitions column definitions carry correct typed keys
    Given the DriverLogonCardTableColumnDefinitions factory is invoked
    When the column definitions are retrieved
    Then the "DateTime" column field type resolves to a date-time string type
      And the "Driver" column field type resolves to a driver object type
      And the "Location" column field type resolves to a location object type
      And the "Status" column field type resolves to a logon status enum type

  @api @regression
  Scenario: DriverLogonCardTableColumnDefinitions rejects an undefined row data shape at compile contract boundary
    Given a consumer attempts to provide an untyped row data object previously typed as "$TSFixMe"
    When the column definition contract is evaluated
    Then a type mismatch is reported at the API contract boundary
      And the consumer is required to supply a correctly-shaped typed row object

  @ui @smoke
  Scenario: DateTimeLogonCell renders a valid logon timestamp correctly
    Given a DateTimeLogonCell component is rendered with a valid ISO 8601 timestamp "2024-03-15T08:30:00Z"
    When the cell is displayed in the driver logon card table
    Then the formatted date "15 Mar 2024" is visible in the cell
      And the formatted time "08:30 AM" is visible in the cell

  @ui @regression
  Scenario: DateTimeLogonCell renders a null timestamp as an empty cell
    Given a DateTimeLogonCell component is rendered with a null timestamp value
    When the cell is displayed in the driver logon card table
    Then the cell content is empty
      And no error or exception is thrown

  @ui @regression
  Scenario: DateTimeLogonCell renders an undefined timestamp as an empty cell
    Given a DateTimeLogonCell component is rendered with an undefined timestamp value
    When the cell is displayed in the driver logon card table
    Then the cell content is empty
      And no error or exception is thrown

  @ui @regression
  Scenario: DateTimeLogonCell applies correct accessibility attributes
    Given a DateTimeLogonCell component is rendered with a valid ISO 8601 timestamp "2024-06-01T13:45:00Z"
    When the cell is displayed in the driver logon card table
    Then the cell element has an accessible label containing the full datetime string
      And the cell is not interactive

  @api @smoke
  Scenario: DateTimeLogonCell prop contract accepts a correctly-typed DateTimeLogonCellProps object
    Given a valid "DateTimeLogonCellProps" object with a typed timestamp string is prepared
    When it is passed to the DateTimeLogonCell component API contract validator
    Then no type errors are reported
      And the component renders without runtime exceptions

  @api @regression
  Scenario: DateTimeLogonCell prop contract rejects an untyped any-typed timestamp previously using $TSFixMe
    Given a consumer passes a plain "any" typed timestamp value previously acceptable under $TSFixMe
    When the DateTimeLogonCell API contract is evaluated
    Then a type violation is detected at the prop boundary
      And the consumer is required to supply a typed timestamp string

  @api @smoke
  Scenario: DriverCell renders the driver's full name from a typed DriverInfo object
    Given a DriverCell receives a typed DriverInfo object with firstName "Jane" and lastName "Smith"
    When the cell is rendered in the driver logon card table
    Then the cell displays "Jane Smith"

  @api @regression
  Scenario: DriverCell renders a placeholder when driver information is absent
    Given a DriverCell receives a typed DriverInfo object with null driver fields
    When the cell is rendered in the driver logon card table
    Then the cell displays a dash or empty placeholder
      And no runtime error is thrown

  @api @regression
  Scenario: DriverCell prop contract rejects an untyped driver object previously typed as $TSFixMe
    Given a consumer provides an untyped driver payload previously accepted via $TSFixMe
    When the DriverCell API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply a valid DriverInfo typed object

  @api @smoke
  Scenario: LocationCell renders the location name from a typed LocationData object
    Given a LocationCell receives a typed LocationData object with address "123 Fleet Street, Auckland"
    When the cell is rendered in the driver logon card table
    Then the cell displays "123 Fleet Street, Auckland"

  @api @regression
  Scenario: LocationCell renders a placeholder when location data is null
    Given a LocationCell receives a typed LocationData object with a null address field
    When the cell is rendered in the driver logon card table
    Then the cell displays a dash or empty placeholder
      And no runtime error is thrown

  @api @regression
  Scenario: LocationCell prop contract enforces a typed LocationData object
    Given a consumer provides an untyped location payload previously typed as $TSFixMe
    When the LocationCell API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply a valid LocationData typed object

  @api @smoke
  Scenario: StatusCell renders "Logged In" status for a typed LOGGED_IN enum value
    Given a StatusCell receives a typed logon status value of "LOGGED_IN"
    When the cell is rendered in the driver logon card table
    Then the cell displays the label "Logged In"
      And the status indicator is styled as active

  @api @smoke
  Scenario: StatusCell renders "Logged Out" status for a typed LOGGED_OUT enum value
    Given a StatusCell receives a typed logon status value of "LOGGED_OUT"
    When the cell is rendered in the driver logon card table
    Then the cell displays the label "Logged Out"
      And the status indicator is styled as inactive

  @api @regression
  Scenario: StatusCell renders a neutral state for an unknown typed status value
    Given a StatusCell receives a typed logon status value of "UNKNOWN"
    When the cell is rendered in the driver logon card table
    Then the cell displays a neutral label or dash
      And no runtime error is thrown

  @api @regression
  Scenario: StatusCell prop contract rejects an untyped status string previously typed as $TSFixMe
    Given a consumer provides a raw untyped status string previously accepted via $TSFixMe
    When the StatusCell API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply a value conforming to the LogonStatus enum type

  @api @smoke
  Scenario: DataRetention component loads the current retention period from the typed API response
    Given the Dashcam API returns a typed DataRetentionSettings object with retentionDays 30
    When the DataRetention component is initialised
    Then the displayed retention period shows "30 days"

  @api @regression
  Scenario: DataRetention component handles an API response with the minimum retention period
    Given the Dashcam API returns a typed DataRetentionSettings object with retentionDays 7
    When the DataRetention component is initialised
    Then the displayed retention period shows "7 days"
      And the decrease retention period action is disabled

  @api @regression
  Scenario: DataRetention component handles an API response with the maximum retention period
    Given the Dashcam API returns a typed DataRetentionSettings object with retentionDays 90
    When the DataRetention component is initialised
    Then the displayed retention period shows "90 days"
      And the increase retention period action is disabled

  @api @regression
  Scenario: DataRetention component handles a failed API response gracefully
    Given the Dashcam API returns a 500 Internal Server Error for the retention settings endpoint
    When the DataRetention component is initialised
    Then an error notification is displayed to the user
      And the retention period display is not rendered

  @api @regression
  Scenario: DataRetention API contract rejects an untyped retention settings payload previously using $TSFixMe
    Given a consumer provides an untyped retention settings payload previously accepted via $TSFixMe
    When the DataRetention API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply a valid DataRetentionSettings typed object

  @api @smoke
  Scenario: DataRetentionPeriodUpdateModal opens with the current retention period pre-populated
    Given the DataRetention component has loaded a current retention period of 30 days
    When the user opens the DataRetentionPeriodUpdateModal
    Then the modal is visible
      And the retention period input field is pre-populated with the value 30

  @api @smoke
  Scenario: DataRetentionPeriodUpdateModal successfully submits a valid new retention period
    Given the DataRetentionPeriodUpdateModal is open with the current period of 30 days
    When the user changes the retention period to 60 days
      And the user confirms the update
    Then the Dashcam API receives a typed PUT request with retentionDays 60
      And the modal closes
      And a success notification is displayed

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal rejects a retention period below the minimum allowed value
    Given the DataRetentionPeriodUpdateModal is open
    When the user enters a retention period of 0 days
      And the user attempts to confirm the update
    Then a validation error message is displayed within the modal
      And the API is not called
      And the modal remains open

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal rejects a retention period above the maximum allowed value
    Given the DataRetentionPeriodUpdateModal is open
    When the user enters a retention period of 999 days
      And the user attempts to confirm the update
    Then a validation error message is displayed within the modal
      And the API is not called
      And the modal remains open

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal cancels without making API changes
    Given the DataRetentionPeriodUpdateModal is open with the current period of 30 days
    When the user changes the retention period to 60 days
      And the user clicks Cancel
    Then the modal closes
      And the Dashcam API is not called
      And the displayed retention period remains 30 days

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal handles an API error on submission gracefully
    Given the DataRetentionPeriodUpdateModal is open with the current period of 30 days
    When the user changes the retention period to 60 days
      And the user confirms the update
      And the Dashcam API returns a 503 Service Unavailable response
    Then an error notification is displayed within the modal
      And the modal remains open
      And the retention period input retains the value 60

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal prop contract enforces typed onConfirm and onCancel callbacks
    Given a consumer wires up DataRetentionPeriodUpdateModal with untyped callback functions previously using $TSFixMe
    When the modal API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply correctly-typed onConfirm and onCancel handlers

  @api @smoke
  Scenario: OfflineNotifications displays a notification when a dashcam device goes offline
    Given the Dashcam real-time event stream emits a typed OfflineEvent for device "CAM-001"
    When the OfflineNotifications component processes the event
    Then a notification banner is displayed with the message containing "CAM-001 is offline"

  @api @smoke
  Scenario: OfflineNotifications clears the notification when the device comes back online
    Given an offline notification is active for device "CAM-001"
    When the Dashcam real-time event stream emits a typed OnlineEvent for device "CAM-001"
    Then the offline notification for "CAM-001" is dismissed automatically

  @api @regression
  Scenario: OfflineNotifications handles multiple simultaneous offline devices
    Given the Dashcam event stream emits typed OfflineEvents for devices "CAM-001", "CAM-002", and "CAM-003"
    When the OfflineNotifications component processes all events
    Then three separate offline notifications are displayed, one per device

  @api @regression
  Scenario: OfflineNotifications does not display a notification for an unknown or malformed device event
    Given the Dashcam event stream emits a typed OfflineEvent with a null deviceId
    When the OfflineNotifications component processes the event
    Then no notification is displayed
      And the error is logged internally without crashing the component

  @api @regression
  Scenario: OfflineNotifications prop contract rejects an untyped event payload previously using $TSFixMe
    Given a consumer provides an untyped offline event payload previously accepted via $TSFixMe
    When the OfflineNotifications API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply a valid typed OfflineEvent object

  @ui @smoke
  Scenario: Dashcam API layer returns a typed response for the driver logon list endpoint
    Given the user navigates to the Dashcam driver logon section
    When the system calls the typed getDriverLogonList API function
    Then a list of typed DriverLogonRecord objects is returned
      And each record contains typed DateTime, Driver, Location, and Status fields

  @ui @regression
  Scenario: Dashcam API layer surfaces a user-visible error when the driver logon list endpoint fails
    Given the user is on the Dashcam driver logon section
    When the typed getDriverLogonList API call returns a 401 Unauthorised response
    Then the UI displays an authentication error message
      And the driver logon table is not populated

  @ui @regression
  Scenario: Dashcam API layer surfaces a user-visible error when the data retention endpoint returns a network timeout
    Given the user is on the Dashcam settings page
    When the typed getDataRetentionSettings API call times out after 10 seconds
    Then the UI displays a "Unable to load settings" error message
      And a retry option is presented to the user

  @api @smoke
  Scenario: Typed getDriverLogonList API function returns a correctly-typed DriverLogonRecord array
    Given the Dashcam backend returns a valid JSON array of driver logon records
    When getDriverLogonList is invoked via the typed API layer
    Then the return type is inferred as DriverLogonRecord[]
      And each element has typed fields: id, driverInfo, location, status, and timestamp

  @api @smoke
  Scenario: Typed getDataRetentionSettings API function returns a correctly-typed DataRetentionSettings object
    Given the Dashcam backend returns a valid JSON object with retentionDays 45
    When getDataRetentionSettings is invoked via the typed API layer
    Then the return type is inferred as DataRetentionSettings
      And the retentionDays field is typed as a number with value 45

  @api @smoke
  Scenario: Typed updateDataRetentionPeriod API function sends a correctly-typed request body
    Given a valid typed DataRetentionUpdateRequest with retentionDays 60 is prepared
    When updateDataRetentionPeriod is invoked via the typed API layer
    Then the HTTP PUT request body contains retentionDays 60 as a number
      And the response is mapped to a typed DataRetentionSettings object

  @api @regression
  Scenario: Typed API layer rejects an untyped API response body that previously passed through $TSFixMe
    Given the Dashcam backend returns a JSON response with unexpected extra fields
    When the typed API layer processes the response
    Then unexpected fields are stripped or rejected at the type boundary
      And no untyped data is propagated to consuming components

  @api @regression
  Scenario: Typed API functions handle a 404 Not Found response with a typed ApiError object
    Given the Dashcam backend returns a 404 for a specific resource
    When a typed API function is invoked for that resource
    Then a typed ApiError object is returned with statusCode 404
      And the error message is a non-empty string

  @api @regression
  Scenario: Typed API functions handle a 403 Forbidden response and surface an authorisation error
    Given the current user does not have Dashcam administration permissions
    When a typed API function requiring admin access is invoked
    Then a typed ApiError object is returned with statusCode 403
      And the error category is "AUTHORISATION"

  @api @smoke
  Scenario: SettingsToggle renders in the enabled state when the typed setting value is true
    Given a SettingsToggle receives a typed DashcamSetting object with enabled set to true
    When the component is rendered
    Then the toggle is visually in the ON position

  @api @smoke
  Scenario: SettingsToggle renders in the disabled state when the typed setting value is false
    Given a SettingsToggle receives a typed DashcamSetting object with enabled set to false
    When the component is rendered
    Then the toggle is visually in the OFF position

  @api @smoke
  Scenario: SettingsToggle invokes the typed onChange callback with the new boolean state on user interaction
    Given a SettingsToggle is rendered with a typed onChange handler
    When the user clicks the toggle to change from OFF to ON
    Then the typed onChange callback is invoked with the boolean value true

  @api @regression
  Scenario: SettingsToggle is non-interactive when the typed setting is marked as readOnly
    Given a SettingsToggle receives a typed DashcamSetting object with readOnly set to true
    When the user attempts to click the toggle
    Then the toggle state does not change
      And the onChange callback is not invoked

  @api @regression
  Scenario: SettingsToggle displays a loading indicator while the API persists the setting change
    Given a SettingsToggle is rendered with a typed onChange handler that triggers an asynchronous API call
    When the user clicks the toggle
    Then a loading indicator is displayed on the toggle
      And the toggle is non-interactive during the loading state
      And the loading indicator is dismissed once the API call resolves

  @api @regression
  Scenario: SettingsToggle reverts to the previous state and shows an error when the API call fails
    Given a SettingsToggle is rendered in the OFF state
    When the user clicks the toggle to turn it ON
      And the API call to persist the setting change returns a 500 error
    Then the toggle reverts to the OFF state
      And an error notification is displayed

  @api @regression
  Scenario: SettingsToggle prop contract rejects an untyped setting object previously using $TSFixMe
    Given a consumer provides an untyped setting payload previously accepted via $TSFixMe
    When the SettingsToggle API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply a valid DashcamSetting typed object

  @api @smoke
  Scenario: All exported Dashcam domain types are resolvable and non-any after the $TSFixMe removal
    Given the Dashcam domain types module is imported
    When each exported type is inspected at the API contract level
    Then no exported type resolves to "any" or "$TSFixMe"
      And every exported type has at least one explicitly-typed field

  @api @regression
  Scenario: DriverLogonRecord type enforces all required fields as non-optional
    Given the DriverLogonRecord type definition is inspected
    When a consumer constructs a DriverLogonRecord with a missing required field
    Then a compile-time type error is raised for the missing field
      And the consumer is required to supply the missing typed value

  @api @regression
  Scenario: LogonStatus enum type contains only the defined allowed values
    Given the LogonStatus enum type definition is inspected
    When a consumer attempts to assign a string value not in the enum to a LogonStatus field
    Then a compile-time type error is raised
      And the consumer is required to use one of the defined enum values

  @api @regression
  Scenario: DataRetentionSettings type enforces retentionDays as a positive number
    Given the DataRetentionSettings type definition is inspected
    When a consumer constructs a DataRetentionSettings object with retentionDays typed as a string
    Then a compile-time type error is raised
      And the consumer is required to supply retentionDays as a number

  @api @regression
  Scenario: DashcamSetting type enforces the enabled and readOnly fields as boolean
    Given the DashcamSetting type definition is inspected
    When a consumer constructs a DashcamSetting object with enabled typed as a string "true"
    Then a compile-time type error is raised
      And the consumer is required to supply enabled as a strict boolean value

  @api @regression
  Scenario: OfflineEvent type enforces deviceId as a non-nullable string
    Given the OfflineEvent type definition is inspected
    When a consumer constructs an OfflineEvent with deviceId set to null
    Then a compile-time type error is raised
      And the consumer is required to supply deviceId as a non-null string

  @api @regression
  Scenario: Breaking change — consumers using $TSFixMe-typed Dashcam APIs receive compile errors after upgrade
    Given a legacy consumer module that imported Dashcam components relying on $TSFixMe typings
      And the myeroad platform is running
      And the user is authenticated with a valid fleet management session
      And the Dashcam domain services are available
    When the consumer module is compiled against the updated strictly-typed Dashcam domain
    Then compile-time type errors are raised for each previously-untyped usage
      And the consumer module must be updated to supply correctly-typed arguments and propsFeature: VSF-3500 Dashcam Domain TypeScript Type-Safety — Driver Logon Card, Data Retention, Offline Notifications, API, Settings

  @api @smoke
  Scenario: DriverLogonCardTableColumnDefinitions returns all four typed column definitions
    Given the DriverLogonCardTableColumnDefinitions factory is invoked
    When the column definitions are retrieved
    Then the response contains exactly four columns: "DateTime", "Driver", "Location", "Status"
      And each column definition has a strictly-typed "field", "header", and "renderCell" property

  @api @regression
  Scenario: DriverLogonCardTableColumnDefinitions column definitions carry correct typed keys
    Given the DriverLogonCardTableColumnDefinitions factory is invoked
    When the column definitions are retrieved
    Then the "DateTime" column field type resolves to a date-time string type
      And the "Driver" column field type resolves to a driver object type
      And the "Location" column field type resolves to a location object type
      And the "Status" column field type resolves to a logon status enum type

  @api @regression
  Scenario: DriverLogonCardTableColumnDefinitions rejects an undefined row data shape at compile contract boundary
    Given a consumer attempts to provide an untyped row data object previously typed as "$TSFixMe"
    When the column definition contract is evaluated
    Then a type mismatch is reported at the API contract boundary
      And the consumer is required to supply a correctly-shaped typed row object

  @ui @smoke
  Scenario: DateTimeLogonCell renders a valid logon timestamp correctly
    Given a DateTimeLogonCell component is rendered with a valid ISO 8601 timestamp "2024-03-15T08:30:00Z"
    When the cell is displayed in the driver logon card table
    Then the formatted date "15 Mar 2024" is visible in the cell
      And the formatted time "08:30 AM" is visible in the cell

  @ui @regression
  Scenario: DateTimeLogonCell renders a null timestamp as an empty cell
    Given a DateTimeLogonCell component is rendered with a null timestamp value
    When the cell is displayed in the driver logon card table
    Then the cell content is empty
      And no error or exception is thrown

  @ui @regression
  Scenario: DateTimeLogonCell renders an undefined timestamp as an empty cell
    Given a DateTimeLogonCell component is rendered with an undefined timestamp value
    When the cell is displayed in the driver logon card table
    Then the cell content is empty
      And no error or exception is thrown

  @ui @regression
  Scenario: DateTimeLogonCell applies correct accessibility attributes
    Given a DateTimeLogonCell component is rendered with a valid ISO 8601 timestamp "2024-06-01T13:45:00Z"
    When the cell is displayed in the driver logon card table
    Then the cell element has an accessible label containing the full datetime string
      And the cell is not interactive

  @api @smoke
  Scenario: DateTimeLogonCell prop contract accepts a correctly-typed DateTimeLogonCellProps object
    Given a valid "DateTimeLogonCellProps" object with a typed timestamp string is prepared
    When it is passed to the DateTimeLogonCell component API contract validator
    Then no type errors are reported
      And the component renders without runtime exceptions

  @api @regression
  Scenario: DateTimeLogonCell prop contract rejects an untyped any-typed timestamp previously using $TSFixMe
    Given a consumer passes a plain "any" typed timestamp value previously acceptable under $TSFixMe
    When the DateTimeLogonCell API contract is evaluated
    Then a type violation is detected at the prop boundary
      And the consumer is required to supply a typed timestamp string

  @api @smoke
  Scenario: DriverCell renders the driver's full name from a typed DriverInfo object
    Given a DriverCell receives a typed DriverInfo object with firstName "Jane" and lastName "Smith"
    When the cell is rendered in the driver logon card table
    Then the cell displays "Jane Smith"

  @api @regression
  Scenario: DriverCell renders a placeholder when driver information is absent
    Given a DriverCell receives a typed DriverInfo object with null driver fields
    When the cell is rendered in the driver logon card table
    Then the cell displays a dash or empty placeholder
      And no runtime error is thrown

  @api @regression
  Scenario: DriverCell prop contract rejects an untyped driver object previously typed as $TSFixMe
    Given a consumer provides an untyped driver payload previously accepted via $TSFixMe
    When the DriverCell API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply a valid DriverInfo typed object

  @api @smoke
  Scenario: LocationCell renders the location name from a typed LocationData object
    Given a LocationCell receives a typed LocationData object with address "123 Fleet Street, Auckland"
    When the cell is rendered in the driver logon card table
    Then the cell displays "123 Fleet Street, Auckland"

  @api @regression
  Scenario: LocationCell renders a placeholder when location data is null
    Given a LocationCell receives a typed LocationData object with a null address field
    When the cell is rendered in the driver logon card table
    Then the cell displays a dash or empty placeholder
      And no runtime error is thrown

  @api @regression
  Scenario: LocationCell prop contract enforces a typed LocationData object
    Given a consumer provides an untyped location payload previously typed as $TSFixMe
    When the LocationCell API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply a valid LocationData typed object

  @api @smoke
  Scenario: StatusCell renders "Logged In" status for a typed LOGGED_IN enum value
    Given a StatusCell receives a typed logon status value of "LOGGED_IN"
    When the cell is rendered in the driver logon card table
    Then the cell displays the label "Logged In"
      And the status indicator is styled as active

  @api @smoke
  Scenario: StatusCell renders "Logged Out" status for a typed LOGGED_OUT enum value
    Given a StatusCell receives a typed logon status value of "LOGGED_OUT"
    When the cell is rendered in the driver logon card table
    Then the cell displays the label "Logged Out"
      And the status indicator is styled as inactive

  @api @regression
  Scenario: StatusCell renders a neutral state for an unknown typed status value
    Given a StatusCell receives a typed logon status value of "UNKNOWN"
    When the cell is rendered in the driver logon card table
    Then the cell displays a neutral label or dash
      And no runtime error is thrown

  @api @regression
  Scenario: StatusCell prop contract rejects an untyped status string previously typed as $TSFixMe
    Given a consumer provides a raw untyped status string previously accepted via $TSFixMe
    When the StatusCell API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply a value conforming to the LogonStatus enum type

  @api @smoke
  Scenario: DataRetention component loads the current retention period from the typed API response
    Given the Dashcam API returns a typed DataRetentionSettings object with retentionDays 30
    When the DataRetention component is initialised
    Then the displayed retention period shows "30 days"

  @api @regression
  Scenario: DataRetention component handles an API response with the minimum retention period
    Given the Dashcam API returns a typed DataRetentionSettings object with retentionDays 7
    When the DataRetention component is initialised
    Then the displayed retention period shows "7 days"
      And the decrease retention period action is disabled

  @api @regression
  Scenario: DataRetention component handles an API response with the maximum retention period
    Given the Dashcam API returns a typed DataRetentionSettings object with retentionDays 90
    When the DataRetention component is initialised
    Then the displayed retention period shows "90 days"
      And the increase retention period action is disabled

  @api @regression
  Scenario: DataRetention component handles a failed API response gracefully
    Given the Dashcam API returns a 500 Internal Server Error for the retention settings endpoint
    When the DataRetention component is initialised
    Then an error notification is displayed to the user
      And the retention period display is not rendered

  @api @regression
  Scenario: DataRetention API contract rejects an untyped retention settings payload previously using $TSFixMe
    Given a consumer provides an untyped retention settings payload previously accepted via $TSFixMe
    When the DataRetention API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply a valid DataRetentionSettings typed object

  @api @smoke
  Scenario: DataRetentionPeriodUpdateModal opens with the current retention period pre-populated
    Given the DataRetention component has loaded a current retention period of 30 days
    When the user opens the DataRetentionPeriodUpdateModal
    Then the modal is visible
      And the retention period input field is pre-populated with the value 30

  @api @smoke
  Scenario: DataRetentionPeriodUpdateModal successfully submits a valid new retention period
    Given the DataRetentionPeriodUpdateModal is open with the current period of 30 days
    When the user changes the retention period to 60 days
      And the user confirms the update
    Then the Dashcam API receives a typed PUT request with retentionDays 60
      And the modal closes
      And a success notification is displayed

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal rejects a retention period below the minimum allowed value
    Given the DataRetentionPeriodUpdateModal is open
    When the user enters a retention period of 0 days
      And the user attempts to confirm the update
    Then a validation error message is displayed within the modal
      And the API is not called
      And the modal remains open

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal rejects a retention period above the maximum allowed value
    Given the DataRetentionPeriodUpdateModal is open
    When the user enters a retention period of 999 days
      And the user attempts to confirm the update
    Then a validation error message is displayed within the modal
      And the API is not called
      And the modal remains open

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal cancels without making API changes
    Given the DataRetentionPeriodUpdateModal is open with the current period of 30 days
    When the user changes the retention period to 60 days
      And the user clicks Cancel
    Then the modal closes
      And the Dashcam API is not called
      And the displayed retention period remains 30 days

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal handles an API error on submission gracefully
    Given the DataRetentionPeriodUpdateModal is open with the current period of 30 days
    When the user changes the retention period to 60 days
      And the user confirms the update
      And the Dashcam API returns a 503 Service Unavailable response
    Then an error notification is displayed within the modal
      And the modal remains open
      And the retention period input retains the value 60

  @api @regression
  Scenario: DataRetentionPeriodUpdateModal prop contract enforces typed onConfirm and onCancel callbacks
    Given a consumer wires up DataRetentionPeriodUpdateModal with untyped callback functions previously using $TSFixMe
    When the modal API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply correctly-typed onConfirm and onCancel handlers

  @api @smoke
  Scenario: OfflineNotifications displays a notification when a dashcam device goes offline
    Given the Dashcam real-time event stream emits a typed OfflineEvent for device "CAM-001"
    When the OfflineNotifications component processes the event
    Then a notification banner is displayed with the message containing "CAM-001 is offline"

  @api @smoke
  Scenario: OfflineNotifications clears the notification when the device comes back online
    Given an offline notification is active for device "CAM-001"
    When the Dashcam real-time event stream emits a typed OnlineEvent for device "CAM-001"
    Then the offline notification for "CAM-001" is dismissed automatically

  @api @regression
  Scenario: OfflineNotifications handles multiple simultaneous offline devices
    Given the Dashcam event stream emits typed OfflineEvents for devices "CAM-001", "CAM-002", and "CAM-003"
    When the OfflineNotifications component processes all events
    Then three separate offline notifications are displayed, one per device

  @api @regression
  Scenario: OfflineNotifications does not display a notification for an unknown or malformed device event
    Given the Dashcam event stream emits a typed OfflineEvent with a null deviceId
    When the OfflineNotifications component processes the event
    Then no notification is displayed
      And the error is logged internally without crashing the component

  @api @regression
  Scenario: OfflineNotifications prop contract rejects an untyped event payload previously using $TSFixMe
    Given a consumer provides an untyped offline event payload previously accepted via $TSFixMe
    When the OfflineNotifications API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply a valid typed OfflineEvent object

  @ui @smoke
  Scenario: Dashcam API layer returns a typed response for the driver logon list endpoint
    Given the user navigates to the Dashcam driver logon section
    When the system calls the typed getDriverLogonList API function
    Then a list of typed DriverLogonRecord objects is returned
      And each record contains typed DateTime, Driver, Location, and Status fields

  @ui @regression
  Scenario: Dashcam API layer surfaces a user-visible error when the driver logon list endpoint fails
    Given the user is on the Dashcam driver logon section
    When the typed getDriverLogonList API call returns a 401 Unauthorised response
    Then the UI displays an authentication error message
      And the driver logon table is not populated

  @ui @regression
  Scenario: Dashcam API layer surfaces a user-visible error when the data retention endpoint returns a network timeout
    Given the user is on the Dashcam settings page
    When the typed getDataRetentionSettings API call times out after 10 seconds
    Then the UI displays a "Unable to load settings" error message
      And a retry option is presented to the user

  @api @smoke
  Scenario: Typed getDriverLogonList API function returns a correctly-typed DriverLogonRecord array
    Given the Dashcam backend returns a valid JSON array of driver logon records
    When getDriverLogonList is invoked via the typed API layer
    Then the return type is inferred as DriverLogonRecord[]
      And each element has typed fields: id, driverInfo, location, status, and timestamp

  @api @smoke
  Scenario: Typed getDataRetentionSettings API function returns a correctly-typed DataRetentionSettings object
    Given the Dashcam backend returns a valid JSON object with retentionDays 45
    When getDataRetentionSettings is invoked via the typed API layer
    Then the return type is inferred as DataRetentionSettings
      And the retentionDays field is typed as a number with value 45

  @api @smoke
  Scenario: Typed updateDataRetentionPeriod API function sends a correctly-typed request body
    Given a valid typed DataRetentionUpdateRequest with retentionDays 60 is prepared
    When updateDataRetentionPeriod is invoked via the typed API layer
    Then the HTTP PUT request body contains retentionDays 60 as a number
      And the response is mapped to a typed DataRetentionSettings object

  @api @regression
  Scenario: Typed API layer rejects an untyped API response body that previously passed through $TSFixMe
    Given the Dashcam backend returns a JSON response with unexpected extra fields
    When the typed API layer processes the response
    Then unexpected fields are stripped or rejected at the type boundary
      And no untyped data is propagated to consuming components

  @api @regression
  Scenario: Typed API functions handle a 404 Not Found response with a typed ApiError object
    Given the Dashcam backend returns a 404 for a specific resource
    When a typed API function is invoked for that resource
    Then a typed ApiError object is returned with statusCode 404
      And the error message is a non-empty string

  @api @regression
  Scenario: Typed API functions handle a 403 Forbidden response and surface an authorisation error
    Given the current user does not have Dashcam administration permissions
    When a typed API function requiring admin access is invoked
    Then a typed ApiError object is returned with statusCode 403
      And the error category is "AUTHORISATION"

  @api @smoke
  Scenario: SettingsToggle renders in the enabled state when the typed setting value is true
    Given a SettingsToggle receives a typed DashcamSetting object with enabled set to true
    When the component is rendered
    Then the toggle is visually in the ON position

  @api @smoke
  Scenario: SettingsToggle renders in the disabled state when the typed setting value is false
    Given a SettingsToggle receives a typed DashcamSetting object with enabled set to false
    When the component is rendered
    Then the toggle is visually in the OFF position

  @api @smoke
  Scenario: SettingsToggle invokes the typed onChange callback with the new boolean state on user interaction
    Given a SettingsToggle is rendered with a typed onChange handler
    When the user clicks the toggle to change from OFF to ON
    Then the typed onChange callback is invoked with the boolean value true

  @api @regression
  Scenario: SettingsToggle is non-interactive when the typed setting is marked as readOnly
    Given a SettingsToggle receives a typed DashcamSetting object with readOnly set to true
    When the user attempts to click the toggle
    Then the toggle state does not change
      And the onChange callback is not invoked

  @api @regression
  Scenario: SettingsToggle displays a loading indicator while the API persists the setting change
    Given a SettingsToggle is rendered with a typed onChange handler that triggers an asynchronous API call
    When the user clicks the toggle
    Then a loading indicator is displayed on the toggle
      And the toggle is non-interactive during the loading state
      And the loading indicator is dismissed once the API call resolves

  @api @regression
  Scenario: SettingsToggle reverts to the previous state and shows an error when the API call fails
    Given a SettingsToggle is rendered in the OFF state
    When the user clicks the toggle to turn it ON
      And the API call to persist the setting change returns a 500 error
    Then the toggle reverts to the OFF state
      And an error notification is displayed

  @api @regression
  Scenario: SettingsToggle prop contract rejects an untyped setting object previously using $TSFixMe
    Given a consumer provides an untyped setting payload previously accepted via $TSFixMe
    When the SettingsToggle API contract is evaluated
    Then a type mismatch error is raised
      And the consumer must supply a valid DashcamSetting typed object

  @api @smoke
  Scenario: All exported Dashcam domain types are resolvable and non-any after the $TSFixMe removal
    Given the Dashcam domain types module is imported
    When each exported type is inspected at the API contract level
    Then no exported type resolves to "any" or "$TSFixMe"
      And every exported type has at least one explicitly-typed field

  @api @regression
  Scenario: DriverLogonRecord type enforces all required fields as non-optional
    Given the DriverLogonRecord type definition is inspected
    When a consumer constructs a DriverLogonRecord with a missing required field
    Then a compile-time type error is raised for the missing field
      And the consumer is required to supply the missing typed value

  @api @regression
  Scenario: LogonStatus enum type contains only the defined allowed values
    Given the LogonStatus enum type definition is inspected
    When a consumer attempts to assign a string value not in the enum to a LogonStatus field
    Then a compile-time type error is raised
      And the consumer is required to use one of the defined enum values

  @api @regression
  Scenario: DataRetentionSettings type enforces retentionDays as a positive number
    Given the DataRetentionSettings type definition is inspected
    When a consumer constructs a DataRetentionSettings object with retentionDays typed as a string
    Then a compile-time type error is raised
      And the consumer is required to supply retentionDays as a number

  @api @regression
  Scenario: DashcamSetting type enforces the enabled and readOnly fields as boolean
    Given the DashcamSetting type definition is inspected
    When a consumer constructs a DashcamSetting object with enabled typed as a string "true"
    Then a compile-time type error is raised
      And the consumer is required to supply enabled as a strict boolean value

  @api @regression
  Scenario: OfflineEvent type enforces deviceId as a non-nullable string
    Given the OfflineEvent type definition is inspected
    When a consumer constructs an OfflineEvent with deviceId set to null
    Then a compile-time type error is raised
      And the consumer is required to supply deviceId as a non-null string

  @api @regression
  Scenario: Breaking change — consumers using $TSFixMe-typed Dashcam APIs receive compile errors after upgrade
    Given a legacy consumer module that imported Dashcam components relying on $TSFixMe typings
    When the consumer module is compiled against the updated strictly-typed Dashcam domain
    Then compile-time type errors are raised for each previously-untyped usage
      And the consumer module must be updated to supply correctly-typed arguments and props

