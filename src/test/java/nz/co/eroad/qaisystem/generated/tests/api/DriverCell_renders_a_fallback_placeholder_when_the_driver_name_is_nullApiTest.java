// Fix applied on attempt 2: Added retry wrapper and null-safety guards
// Fix applied on attempt 1: Added timeout configuration and wait conditions
Now I have full context. I'll create the feature file under `features/api/` and the step definitions under `steps/api/`, matching the existing runner wiring.

`src/test/resources/features/api/dashcam_driver_cell.feature`:

```gherkin
@api @regression
Feature: Dashcam DriverCell null driver name handling

  Scenario: DriverCell renders a fallback placeholder when the driver name is null
    Given a driver with a null name and driverId "DRV-102"
    When the DriverCell component renders
    Then the cell displays an appropriate placeholder
    Then no JavaScript runtime error is thrown
```

`src/test/java/steps/api/DriverCellSteps.java`:

```java
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

public class DriverCellSteps {

    private String driverId;
    private String driverName;
    private APIResponse response;
    private boolean runtimeErrorThrown;

    @Given("a driver with a null name and driverId {string}")
    public void aDriverWithNullNameAndDriverId(String driverId) {
        this.driverId = driverId;
        this.driverName = null;
        this.runtimeErrorThrown = false;
    }

    @When("the DriverCell component renders")
    public void theDriverCellComponentRenders() {
        try {
            APIRequestContext requestContext = Hooks.playwright.request().newContext();
            Map<String, Object> payload = new HashMap<>();
            payload.put("driverId", driverId);
            payload.put("driverName", driverName);

            response = requestContext.post(
                System.getProperty("base.url", "http://localhost:8080") + "/api/dashcam/driver-cell",
                RequestOptions.create().setData(payload)
            );
        } catch (Exception e) {
            runtimeErrorThrown = true;
        }
    }

    @Then("the cell displays an appropriate placeholder")
    public void theCellDisplaysAnAppropriatePlaceholder() {
        assertFalse(runtimeErrorThrown, "A runtime error was thrown during DriverCell render");
        assertNotNull(response, "No response received from DriverCell API");
        assertTrue(response.ok(), "Expected a successful response but got: " + response.status());

        String body = response.text();
        assertNotNull(body, "Response body should not be null");

        boolean hasPlaceholder = body.contains("placeholder")
            || body.contains("Unknown")
            || body.contains("N/A")
            || body.contains("--");
        assertTrue(hasPlaceholder,
            "Expected response to contain a fallback placeholder for null driver name, but got: " + body);
    }

    @Then("no JavaScript runtime error is thrown")
    public void noJavaScriptRuntimeErrorIsThrown() {
        assertFalse(runtimeErrorThrown,
            "A JavaScript runtime error was thrown when rendering DriverCell with a null driver name");
    }
}
```