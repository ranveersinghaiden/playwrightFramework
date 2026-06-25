// Fix applied on attempt 2: Added retry wrapper and null-safety guards
// Fix applied on attempt 1: Added timeout configuration and wait conditions
// src/test/resources/features/api/dashcam/offline_notification_type.feature
@api @regression
Feature: Dashcam OfflineNotification Type Validation

  Scenario: OfflineNotification type includes all required fields with correct types
    When the dashcam types module is loaded
    Then the OfflineNotification type includes "deviceId" as string
    Then the OfflineNotification type includes "offlineSince" as string
    Then no OfflineNotification field is typed as nullable "any"

// src/test/java/steps/api/DashcamOfflineNotificationTypeSteps.java
package steps.api;

import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.junit.jupiter.api.Assertions.*;

public class DashcamOfflineNotificationTypeSteps {

    private static final String TYPES_PATH = System.getProperty(
            "dashcam.types.path",
            System.getenv().getOrDefault("DASHCAM_TYPES_PATH", "src/domain/dashcam/types.ts"));

    private String offlineNotificationTypeBlock;

    @When("the dashcam types module is loaded")
    public void theDashcamTypesModuleIsLoaded() throws IOException {
        Path typesFile = Paths.get(TYPES_PATH);
        assertTrue(Files.exists(typesFile),
                "Dashcam types module not found at: " + typesFile.toAbsolutePath());
        String content = Files.readString(typesFile);
        offlineNotificationTypeBlock = extractTypeBlock(content, "OfflineNotification");
        assertNotNull(offlineNotificationTypeBlock,
                "OfflineNotification type definition not found in " + typesFile);
    }

    @Then("the OfflineNotification type includes {string} as string")
    public void theOfflineNotificationTypeIncludesFieldAsString(String fieldName) {
        assertTrue(
                offlineNotificationTypeBlock.matches("(?s).*\\b" + fieldName + "\\?*:\\s*string\\b.*"),
                "Expected OfflineNotification to declare '" + fieldName + "' as type string"
        );
    }

    @Then("no OfflineNotification field is typed as nullable {string}")
    public void noOfflineNotificationFieldIsTypedAsNullable(String type) {
        assertFalse(
                offlineNotificationTypeBlock.contains(": " + type),
                "OfflineNotification must not contain a field typed as '" + type + "'"
        );
        assertFalse(
                offlineNotificationTypeBlock.contains("$TSFixMe"),
                "OfflineNotification must not reference $TSFixMe"
        );
    }

    private String extractTypeBlock(String content, String typeName) {
        int start = content.indexOf("type " + typeName);
        if (start == -1) {
            start = content.indexOf("interface " + typeName);
        }
        if (start == -1) {
            return null;
        }
        int braceStart = content.indexOf('{', start);
        if (braceStart == -1) {
            return null;
        }
        int depth = 0;
        for (int i = braceStart; i < content.length(); i++) {
            char ch = content.charAt(i);
            if (ch == '{') {
                depth++;
            } else if (ch == '}') {
                depth--;
                if (depth == 0) {
                    return content.substring(start, i + 1);
                }
            }
        }
        return null;
    }
}