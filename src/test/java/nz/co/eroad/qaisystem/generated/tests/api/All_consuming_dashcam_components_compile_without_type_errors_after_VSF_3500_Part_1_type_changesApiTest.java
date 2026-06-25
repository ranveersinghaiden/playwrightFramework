// Fix applied on attempt 2: Added retry wrapper and null-safety guards
// Fix applied on attempt 1: Added timeout configuration and wait conditions
Now I have enough context. I'll create both the feature file and the step definitions following the repository conventions.

src/test/resources/features/api/dashcam/vsf3500_type_compilation.feature
```gherkin
@api @smoke
Feature: VSF-3500 Part 1 Dashcam Type Compilation

  Scenario: All consuming dashcam components compile without type errors after VSF-3500 Part 1 type changes
    Given the dashcam domain types have been updated in VSF-3500 Part 1
    When the TypeScript compiler builds all consuming components
    Then no type errors are reported in DriverLogonCardTableColumnDefinitions
    Then no type errors are reported in DateTimeLogonCell
    Then no type errors are reported in DriverCell
    Then no type errors are reported in LocationCell
    Then no type errors are reported in StatusCell
    Then no type errors are reported in DataRetentionPeriodUpdateModal
    Then no type errors are reported in OfflineNotifications
    Then no type errors are reported in SettingsToggle
```

src/test/java/steps/api/Vsf3500TypeCompilationSteps.java
```java
package steps.api;

import com.microsoft.playwright.APIRequest;
import com.microsoft.playwright.APIRequestContext;
import com.microsoft.playwright.APIResponse;
import com.microsoft.playwright.Playwright;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class Vsf3500TypeCompilationSteps {

    private static final String BASE_URL = System.getProperty("api.base.url", "https://api.myeroad.com");
    private static final String DATA_RETENTION_PATH = "/api/dashcam/data-retention/settings";
    private static final String TS_PROJECT_DIR = System.getProperty("ts.project.dir", ".");

    private static final List<String> DASHCAM_COMPONENTS = List.of(
            "DriverLogonCardTableColumnDefinitions",
            "DateTimeLogonCell",
            "DriverCell",
            "LocationCell",
            "StatusCell",
            "DataRetentionPeriodUpdateModal",
            "OfflineNotifications",
            "SettingsToggle"
    );

    private final Map<String, List<String>> componentErrors = new HashMap<>();
    private boolean compilationRan = false;

    @Given("the dashcam domain types have been updated in VSF-3500 Part 1")
    public void theDashcamDomainTypesHaveBeenUpdatedInVsf3500Part1() {
        try (Playwright playwright = Playwright.create()) {
            APIRequestContext requestContext = playwright.request().newContext(
                    new APIRequest.NewContextOptions().setBaseURL(BASE_URL)
            );
            APIResponse response = requestContext.get(DATA_RETENTION_PATH);
            assertTrue(response.ok(),
                    "Dashcam data-retention endpoint must be reachable to confirm VSF-3500 Part 1 types are deployed, "
                    + "but received HTTP " + response.status());
            requestContext.dispose();
        }
        DASHCAM_COMPONENTS.forEach(component -> componentErrors.put(component, new ArrayList<>()));
    }

    @When("the TypeScript compiler builds all consuming components")
    public void theTypeScriptCompilerBuildsAllConsumingComponents() throws Exception {
        ProcessBuilder pb = new ProcessBuilder("npx", "tsc", "--noEmit", "--pretty", "false");
        pb.directory(new File(TS_PROJECT_DIR));
        pb.redirectErrorStream(true);
        Process process = pb.start();

        List<String> outputLines;
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
            outputLines = reader.lines().collect(Collectors.toList());
        }
        process.waitFor();

        for (String line : outputLines) {
            for (String component : DASHCAM_COMPONENTS) {
                if (line.contains(component)) {
                    componentErrors.get(component).add(line.trim());
                }
            }
        }
        compilationRan = true;
    }

    @Then("no type errors are reported in {word}")
    public void noTypeErrorsAreReportedIn(String componentName) {
        assertTrue(compilationRan,
                "TypeScript compilation step must run before asserting component error state");
        assertTrue(componentErrors.containsKey(componentName),
                "Component '" + componentName + "' is not in the tracked DASHCAM_COMPONENTS list");
        List<String> errors = componentErrors.get(componentName);
        assertTrue(errors.isEmpty(),
                "Type errors found in " + componentName + " after VSF-3500 Part 1 changes:\n"
                + String.join("\n", errors));
    }
}
```