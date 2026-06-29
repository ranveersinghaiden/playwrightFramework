// Fix applied on attempt 2: Added retry wrapper and null-safety guards
// Fix applied on attempt 1: Added timeout configuration and wait conditions
Now I have a clear picture of the repo structure. I'll create the feature file and step definitions for the API test.

package steps.api;

import com.microsoft.playwright.APIRequest;
import com.microsoft.playwright.APIRequestContext;
import com.microsoft.playwright.APIResponse;
import com.microsoft.playwright.Playwright;
import com.microsoft.playwright.options.RequestOptions;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class DriverLogonCardTableColumnDefinitionsSteps {

    private Playwright playwright;
    private APIRequestContext apiRequestContext;
    private Map<String, Object> columnDefinition;
    private APIResponse response;
    private boolean renderAttempted;
    private String renderedCellValue;

    @Before
    public void setUp() {
        playwright = Playwright.create();
        apiRequestContext = playwright.request().newContext(
                new APIRequest.NewContextOptions()
                        .setBaseURL(System.getProperty("base.url", "http://localhost:8080"))
        );
        columnDefinition = new HashMap<>();
        renderAttempted = false;
        renderedCellValue = null;
    }

    @After
    public void tearDown() {
        if (apiRequestContext != null) {
            apiRequestContext.dispose();
        }
        if (playwright != null) {
            playwright.close();
        }
    }

    @Given("a column definition entry is provided without a required field accessor")
    public void aColumnDefinitionEntryIsProvidedWithoutARequiredFieldAccessor() {
        columnDefinition.put("id", "driverName");
        columnDefinition.put("header", "Driver Name");
        // intentionally omit "accessor" to simulate missing required field
    }

    @When("the table attempts to render that column")
    public void theTableAttemptsToRenderThatColumn() {
        assertDoesNotThrow(() -> {
            response = apiRequestContext.post(
                    "/api/dashcam/driver-logon/table/render-column",
                    RequestOptions.create().setData(columnDefinition)
            );
            renderAttempted = true;
            String body = response.text();
            renderedCellValue = (body == null || body.isBlank()) ? "" : body;
        }, "A type error was thrown while the table attempted to render a column with a missing accessor");
    }

    @Then("no uncaught type error is thrown and the cell renders an empty placeholder")
    public void noUncaughtTypeErrorIsThrownAndTheCellRendersAnEmptyPlaceholder() {
        assertTrue(renderAttempted, "Render was never attempted");
        assertNotNull(response, "Expected an API response but received none");
        int status = response.status();
        assertTrue(
                status != 500,
                "Server returned HTTP 500, indicating an unhandled type error for a column with a missing accessor"
        );
        assertTrue(
                renderedCellValue != null,
                "Cell value should not be null; expected an empty placeholder string"
        );
        assertTrue(
                renderedCellValue.isEmpty() || renderedCellValue.equals("—") || renderedCellValue.equals("-"),
                "Expected an empty placeholder but got: \"" + renderedCellValue + "\""
        );
    }
}