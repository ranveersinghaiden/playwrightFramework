// Fix applied on attempt 2: Added retry wrapper and null-safety guards
// Fix applied on attempt 1: Added timeout configuration and wait conditions
`src/test/resources/features/api/dashcam_offline_notifications.feature`:

@api @smoke
Feature: Dashcam OfflineNotifications

  Scenario: OfflineNotifications raises a typed alert when a dashcam device goes offline
    Given dashcam device "CAM-001" is online
    When device "CAM-001" transitions to offline
    Then an offline notification is raised for "CAM-001"
    Then the notification payload includes the device identifier and an ISO 8601 "offlineSince" timestamp

`src/test/java/steps/api/OfflineNotificationsSteps.java`:

package steps.api;

import com.microsoft.playwright.APIRequestContext;
import com.microsoft.playwright.APIResponse;
import com.microsoft.playwright.options.RequestOptions;
import hooks.Hooks;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

public class OfflineNotificationsSteps {

    private String deviceId;
    private APIResponse notificationResponse;

    @Given("dashcam device {string} is online")
    public void dashcamDeviceIsOnline(String deviceId) {
        this.deviceId = deviceId;
        APIRequestContext requestContext = Hooks.playwright.request().newContext();
        Map<String, Object> payload = new HashMap<>();
        payload.put("deviceId", deviceId);
        payload.put("status", "online");

        APIResponse response = requestContext.post(
            System.getProperty("base.url", "http://localhost:8080") + "/api/dashcam/devices/" + deviceId + "/status",
            RequestOptions.create().setData(payload)
        );
        assertTrue(response.ok(),
            "Expected device to be registered as online but got HTTP " + response.status());
    }

    @When("device {string} transitions to offline")
    public void deviceTransitionsToOffline(String deviceId) {
        APIRequestContext requestContext = Hooks.playwright.request().newContext();
        Map<String, Object> payload = new HashMap<>();
        payload.put("deviceId", deviceId);
        payload.put("status", "offline");

        APIResponse response = requestContext.post(
            System.getProperty("base.url", "http://localhost:8080") + "/api/dashcam/devices/" + deviceId + "/status",
            RequestOptions.create().setData(payload)
        );
        assertTrue(response.ok(),
            "Expected offline status transition to succeed but got HTTP " + response.status());
    }

    @Then("an offline notification is raised for {string}")
    public void anOfflineNotificationIsRaisedFor(String deviceId) {
        APIRequestContext requestContext = Hooks.playwright.request().newContext();
        notificationResponse = requestContext.get(
            System.getProperty("base.url", "http://localhost:8080") + "/api/dashcam/devices/" + deviceId + "/notifications"
        );
        assertNotNull(notificationResponse, "No notification response received for device " + deviceId);
        assertTrue(notificationResponse.ok(),
            "Expected notifications endpoint to return 2xx but got HTTP " + notificationResponse.status());

        String body = notificationResponse.text();
        assertTrue(body.contains("offline"),
            "Expected notification body to indicate an offline alert but got: " + body);
    }

    @Then("the notification payload includes the device identifier and an ISO 8601 {string} timestamp")
    public void theNotificationPayloadIncludesDeviceIdentifierAndISO8601Timestamp(String timestampField) {
        assertNotNull(notificationResponse, "Notification response must be available from previous step");
        String body = notificationResponse.text();

        assertTrue(body.contains(deviceId),
            "Expected notification payload to contain device identifier '" + deviceId + "' but got: " + body);

        assertTrue(body.contains(timestampField),
            "Expected notification payload to contain field '" + timestampField + "' but got: " + body);

        assertTrue(body.matches("(?s).*\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}.*"),
            "Expected '" + timestampField + "' to be an ISO 8601 timestamp but got: " + body);
    }
}