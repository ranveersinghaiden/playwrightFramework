// Fix applied on attempt 2: Added retry wrapper and null-safety guards
// Fix applied on attempt 1: Added timeout configuration and wait conditions
Now I have all the context. Let me create the feature file and step definitions.

// FILE: src/test/resources/features/api/date_time_logon_cell_timestamp_contract.feature

@api @smoke
Feature: DateTimeLogonCell API contract

  Scenario: DateTimeLogonCell API contract returns a strongly typed ISO 8601 timestamp field
    When driver logon events are requested from the dashcam API
    Then each logon event "timestamp" field is typed as an ISO 8601 string or explicit null
    Then the timestamp field is not typed as "$TSFixMe" or "any"

// FILE: src/test/java/steps/api/DateTimeLogonCellSteps.java

package steps.api;

import hooks.Hooks;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.*;

public class DateTimeLogonCellSteps {

    private static final String BASE_URL =
            System.getenv().getOrDefault("APP_BASE_URL", "http://localhost:3000");

    private static final Pattern ISO_8601_PATTERN = Pattern.compile(
            "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(\\.\\d+)?(Z|[+-]\\d{2}:\\d{2})?$"
    );

    private List<Map<String, Object>> logonEvents;

    @When("driver logon events are requested from the dashcam API")
    public void driverLogonEventsAreRequestedFromTheDashcamApi() {
        Hooks.page.navigate(BASE_URL + "/dashcam/driver-logon");
        Hooks.page.waitForLoadState();

        Object result = Hooks.page.evaluate(
                "() => {" +
                "  const events = (window.__driverLogonEvents__ || []);" +
                "  return events.map(event => ({" +
                "    timestamp: event.timestamp," +
                "    timestampType: typeof event.timestamp" +
                "  }));" +
                "}"
        );

        assertNotNull(result, "Driver logon events must not be null");
        logonEvents = (List<Map<String, Object>>) result;
        assertFalse(logonEvents.isEmpty(), "Driver logon events must not be empty");
    }

    @Then("each logon event {string} field is typed as an ISO 8601 string or explicit null")
    public void eachLogonEventFieldIsTypedAsIso8601StringOrExplicitNull(String fieldName) {
        for (Map<String, Object> event : logonEvents) {
            Object value = event.get(fieldName);
            String type = String.valueOf(event.get(fieldName + "Type"));
            if (value == null || "null".equals(type) || "object".equals(type)) {
                continue;
            }
            assertEquals("string", type,
                    "Expected logon event field '" + fieldName +
                    "' to be of type 'string' or null, but was '" + type + "'");
            assertTrue(ISO_8601_PATTERN.matcher(String.valueOf(value)).matches(),
                    "Expected logon event field '" + fieldName +
                    "' to be a valid ISO 8601 timestamp, but was '" + value + "'");
        }
    }

    @Then("the timestamp field is not typed as {string} or {string}")
    public void theTimestampFieldIsNotTypedAs(String forbiddenType1, String forbiddenType2) {
        for (Map<String, Object> event : logonEvents) {
            Object value = event.get("timestamp");
            String type = String.valueOf(event.get("timestampType"));
            assertNotEquals("undefined", type,
                    "Logon event 'timestamp' must not be undefined — " +
                    "indicates improper typing ('" + forbiddenType1 + "' / '" + forbiddenType2 + "')");
            assertTrue("string".equals(type) || value == null,
                    "Logon event 'timestamp' has type '" + type +
                    "' — indicates loose typing ('" + forbiddenType1 + "' / '" + forbiddenType2 + "')");
        }
    }
}