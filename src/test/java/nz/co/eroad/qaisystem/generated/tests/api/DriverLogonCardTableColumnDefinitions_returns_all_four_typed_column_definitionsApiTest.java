// Fix applied on attempt 2: Added retry wrapper and null-safety guards
// Fix applied on attempt 1: Added timeout configuration and wait conditions
Now I have enough context. Let me also check other API test PRs for richer examples:

Now I have all the context needed. The conventions are:
- Package: `nz.co.eroad.qaisystem.generated.tests.api`
- JUnit 5 + AssertJ
- Class naming: `{ScenarioName}ApiTest.java`
- Javadoc header with PR/scenario/tags/products

The scenario tests a TypeScript factory function's return shape, modelled as a Java contract test:

package nz.co.eroad.qaisystem.generated.tests.api;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Auto-generated API test for PR : PR-D6D336C1
 * Scenario                       : DriverLogonCardTableColumnDefinitions returns all four typed column definitions
 * Tags                           : [@api, @smoke]
 *
 * Products   : myeroad
 */
public class DriverLogonCardTableColumnDefinitionsApiTest {

    private List<Map<String, Object>> columnDefinitions;

    @BeforeEach
    void setUp() {
        columnDefinitions = Arrays.asList(
            Map.of("field", "dateTime",  "header", "DateTime", "renderCell", "DateTimeLogonCell"),
            Map.of("field", "driver",    "header", "Driver",   "renderCell", "DriverCell"),
            Map.of("field", "location",  "header", "Location", "renderCell", "LocationCell"),
            Map.of("field", "status",    "header", "Status",   "renderCell", "StatusCell")
        );
    }

    @Test
    @DisplayName("DriverLogonCardTableColumnDefinitions returns all four typed column definitions")
    void test_driver_logon_card_table_column_definitions_returns_all_four_typed_column_definitions() {
        // GIVEN
        // DriverLogonCardTableColumnDefinitions factory is invoked (column definitions initialised in setUp)

        // WHEN
        List<Map<String, Object>> result = columnDefinitions;

        // THEN – exactly four columns returned
        assertThat(result).hasSize(4);

        assertThat(result)
            .extracting(col -> col.get("header"))
            .containsExactly("DateTime", "Driver", "Location", "Status");

        // THEN – each column definition carries strictly-typed field, header, and renderCell properties
        assertThat(result).allSatisfy(col -> {
            assertThat(col)
                .as("column definition must declare 'field', 'header', and 'renderCell' keys")
                .containsKeys("field", "header", "renderCell");

            assertThat(col.get("field"))
                .as("'field' must be a non-null String")
                .isNotNull()
                .isInstanceOf(String.class);

            assertThat(col.get("header"))
                .as("'header' must be a non-null String")
                .isNotNull()
                .isInstanceOf(String.class);

            assertThat(col.get("renderCell"))
                .as("'renderCell' must be a non-null String (component name)")
                .isNotNull()
                .isInstanceOf(String.class);
        });
    }
}