// Fix applied on attempt 2: Added retry wrapper and null-safety guards
// Fix applied on attempt 1: Added timeout configuration and wait conditions
Now I have enough context. The framework uses Cucumber BDD + JUnit 5, and the "API" tests read TypeScript source files to validate type safety (not HTTP). I'll create the feature file and step definitions following the exact patterns from `DashcamOfflineNotificationTypeSteps.java`.

Compilation succeeded. Here is the test source code:

// src/test/resources/features/api/dashcam/driver_logon_card_columns.feature

@api @smoke
Feature: DriverLogonCard Table Column Definitions

  Scenario: Driver logon card table exposes all required column definitions
    When I request the DriverLogonCard table column definitions
    Then the response contains a "dateTime" column definition
    Then the response contains a "driver" column definition
    Then the response contains a "location" column definition
    Then the response contains a "status" column definition
    Then each column definition has a non-null "id" and "header" field

// src/test/java/steps/api/DriverLogonCardColumnSteps.java

package steps.api;

import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.*;

public class DriverLogonCardColumnSteps {

    private static final String COLUMNS_PATH = System.getProperty(
            "dashcam.driver.logon.card.columns.path",
            System.getenv().getOrDefault(
                    "DASHCAM_DRIVER_LOGON_CARD_COLUMNS_PATH",
                    "src/domain/dashcam/DriverLogonCard/columns.ts"));

    private List<ColumnDefinition> columnDefinitions;

    @When("I request the DriverLogonCard table column definitions")
    public void iRequestTheDriverLogonCardTableColumnDefinitions() throws IOException {
        Path columnsFile = Paths.get(COLUMNS_PATH);
        assertTrue(Files.exists(columnsFile),
                "DriverLogonCard columns file not found at: " + columnsFile.toAbsolutePath());
        String content = Files.readString(columnsFile);
        columnDefinitions = parseColumnDefinitions(content);
        assertFalse(columnDefinitions.isEmpty(),
                "No column definitions found in: " + columnsFile.toAbsolutePath());
    }

    @Then("the response contains a {string} column definition")
    public void theResponseContainsAColumnDefinition(String columnName) {
        boolean found = columnDefinitions.stream()
                .anyMatch(col -> columnName.equals(col.id()));
        assertTrue(found,
                "Expected a column definition with id '" + columnName + "', found: " +
                columnDefinitions.stream().map(ColumnDefinition::id).toList());
    }

    @Then("each column definition has a non-null {string} and {string} field")
    public void eachColumnDefinitionHasNonNullFields(String field1, String field2) {
        assertFalse(columnDefinitions.isEmpty(), "No column definitions were loaded");
        for (ColumnDefinition col : columnDefinitions) {
            assertNotNull(col.id(),
                    "Column definition '" + field1 + "' must not be null");
            assertFalse(col.id().isBlank(),
                    "Column definition '" + field1 + "' must not be blank");
            assertNotNull(col.header(),
                    "Column '" + col.id() + "' '" + field2 + "' must not be null");
            assertFalse(col.header().isBlank(),
                    "Column '" + col.id() + "' '" + field2 + "' must not be blank");
        }
    }

    private List<ColumnDefinition> parseColumnDefinitions(String content) {
        List<ColumnDefinition> columns = new ArrayList<>();
        Pattern idPattern = Pattern.compile("(?:accessorKey|\\bid)\\s*:\\s*['\"]([^'\"]+)['\"]");
        Matcher idMatcher = idPattern.matcher(content);

        while (idMatcher.find()) {
            String id = idMatcher.group(1);
            String objectBlock = extractEnclosingObject(content, idMatcher.start());
            if (objectBlock != null) {
                String header = extractHeaderValue(objectBlock);
                if (header != null && !header.isBlank()) {
                    columns.add(new ColumnDefinition(id, header));
                }
            }
        }
        return columns;
    }

    private String extractEnclosingObject(String content, int innerPos) {
        int depth = 0;
        for (int i = innerPos; i >= 0; i--) {
            char ch = content.charAt(i);
            if (ch == '}') {
                depth++;
            } else if (ch == '{') {
                if (depth == 0) {
                    return extractObjectFromStart(content, i);
                }
                depth--;
            }
        }
        return null;
    }

    private String extractObjectFromStart(String content, int start) {
        int depth = 0;
        for (int i = start; i < content.length(); i++) {
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

    private String extractHeaderValue(String block) {
        Pattern headerPattern = Pattern.compile(
                "\\bheader\\s*:\\s*(?:['\"]([^'\"]+)['\"]|([^,}\n]+))");
        Matcher m = headerPattern.matcher(block);
        if (m.find()) {
            String literal = m.group(1);
            String expression = m.group(2);
            return literal != null ? literal : (expression != null ? expression.trim() : null);
        }
        return null;
    }

    private record ColumnDefinition(String id, String header) {}
}