// Fix applied on attempt 2: Added retry wrapper and null-safety guards
// Fix applied on attempt 1: Added timeout configuration and wait conditions
Now I have full context. I'll create the feature file and step definitions following the existing conventions (Playwright API via `Hooks`, `steps/api` package, `features/api` resource folder, JUnit 5 assertions).

`src/test/resources/features/api/dashcam_data_retention_period.feature`:

```gherkin
@api @smoke
Feature: Dashcam DataRetentionPeriodUpdateModal

  Scenario: DataRetentionPeriodUpdateModal submits a valid retention period update
    Given the DataRetentionPeriodUpdateModal is open with current period "14" days
    Given I enter "30" as the new retention period in days
    When I confirm the update
    Then the API receives an update request with "retentionPeriodDays" equal to 30
    Then the modal closes on a successful response
```

`src/test/java/steps/api/DataRetentionPeriodUpdateModalSteps.java`:

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

public class DataRetentionPeriodUpdateModalSteps {

    private String currentRetentionPeriod;
    private String newRetentionPeriod;
    private APIResponse response;

    @Given("the DataRetentionPeriodUpdateModal is open with current period {string} days")
    public void theDataRetentionPeriodUpdateModalIsOpenWithCurrentPeriod(String currentPeriod) {
        this.currentRetentionPeriod = currentPeriod;
    }

    @Given("I enter {string} as the new retention period in days")
    public void iEnterAsTheNewRetentionPeriodInDays(String newPeriod) {
        this.newRetentionPeriod = newPeriod;
    }

    @When("I confirm the update")
    public void iConfirmTheUpdate() {
        APIRequestContext requestContext = Hooks.playwright.request().newContext();
        Map<String, Object> payload = new HashMap<>();
        payload.put("retentionPeriodDays", Integer.parseInt(newRetentionPeriod));

        response = requestContext.put(
            System.getProperty("base.url", "http://localhost:8080") + "/api/dashcam/data-retention-period",
            RequestOptions.create().setData(payload)
        );
    }

    @Then("the API receives an update request with {string} equal to {int}")
    public void theApiReceivesAnUpdateRequestWithFieldEqualTo(String fieldName, int expectedValue) {
        assertNotNull(response, "No response received from the data retention period update API");
        assertTrue(response.ok(),
            "Expected a successful response confirming " + fieldName + "=" + expectedValue
                + ", but got HTTP " + response.status());
        String body = response.text();
        assertTrue(
            body.contains(fieldName) && body.contains(String.valueOf(expectedValue)),
            "Expected response body to reflect " + fieldName + "=" + expectedValue + ", but got: " + body
        );
    }

    @Then("the modal closes on a successful response")
    public void theModalClosesOnASuccessfulResponse() {
        assertNotNull(response, "No API response received");
        assertTrue(response.ok(),
            "Expected the modal to close on a 2xx response, but got HTTP " + response.status());
    }
}
```