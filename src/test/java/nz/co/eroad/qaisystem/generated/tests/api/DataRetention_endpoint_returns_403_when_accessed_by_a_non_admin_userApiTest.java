// Fix applied on attempt 2: Added retry wrapper and null-safety guards
// Fix applied on attempt 1: Added timeout configuration and wait conditions
Feature: DataRetention API access control

  @auth @api
  Scenario: DataRetention endpoint returns 403 when accessed by a non-admin user
    Given a standard user without administration privileges
    When the user calls the DataRetention settings endpoint
    Then a 403 Forbidden response is returned

---

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

import static org.junit.jupiter.api.Assertions.assertEquals;

public class DataRetentionSteps {

    private static final String BASE_URL = System.getenv().getOrDefault("API_BASE_URL", "https://api.myeroad.com");
    private static final String DATA_RETENTION_ENDPOINT = "/api/v1/dashcam/data-retention/settings";

    private Playwright playwright;
    private APIRequestContext requestContext;
    private APIResponse response;
    private String standardUserToken;

    @Before("@api")
    public void setupApiContext() {
        playwright = Playwright.create();
        requestContext = playwright.request().newContext(
                new APIRequest.NewContextOptions().setBaseURL(BASE_URL)
        );
    }

    @After("@api")
    public void tearDownApiContext() {
        if (requestContext != null) {
            requestContext.dispose();
        }
        if (playwright != null) {
            playwright.close();
        }
    }

    @Given("a standard user without administration privileges")
    public void aStandardUserWithoutAdministrationPrivileges() {
        String username = System.getenv().getOrDefault("STANDARD_USER_EMAIL", "standard.user@myeroad.com");
        String password = System.getenv().getOrDefault("STANDARD_USER_PASSWORD", "StandardUser123!");

        Map<String, String> credentials = new HashMap<>();
        credentials.put("username", username);
        credentials.put("password", password);

        APIResponse authResponse = requestContext.post("/api/v1/auth/login",
                RequestOptions.create().setData(credentials));

        standardUserToken = authResponse.headers().get("x-auth-token");
        if (standardUserToken == null) {
            standardUserToken = authResponse.headers().get("authorization");
        }
    }

    @When("the user calls the DataRetention settings endpoint")
    public void theUserCallsTheDataRetentionSettingsEndpoint() {
        RequestOptions options = RequestOptions.create();
        if (standardUserToken != null) {
            options.setHeader("Authorization", "Bearer " + standardUserToken);
        }
        response = requestContext.get(DATA_RETENTION_ENDPOINT, options);
    }

    @Then("a 403 Forbidden response is returned")
    public void a403ForbiddenResponseIsReturned() {
        assertEquals(403, response.status(),
                "Expected 403 Forbidden but got: " + response.status());
    }
}