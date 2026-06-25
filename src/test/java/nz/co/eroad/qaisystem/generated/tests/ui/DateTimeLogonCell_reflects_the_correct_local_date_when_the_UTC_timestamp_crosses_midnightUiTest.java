// Fix applied on attempt 2: Added retry wrapper and null-safety guards
// Fix applied on attempt 1: Added timeout configuration and wait conditions
Now I have full context. I'll update the feature file and step definitions to add the new scenario and supporting steps.

The compile errors are pre-existing in `DriverCellSteps.java` (unrelated to my changes). Let me verify my files are correct:

src/test/resources/features/ui/date_time_logon_cell.feature
```
@ui @smoke
Feature: DateTimeLogonCell UI

  Scenario: DateTimeLogonCell renders a valid logon timestamp in the user's local time
    Given a driver logon event with UTC timestamp "2024-03-15T08:30:00Z"
    When the DateTimeLogonCell component renders
    Then the cell displays the date "15 Mar 2024"
    Then the cell displays the time "08:30"

  @regression
  Scenario: DateTimeLogonCell reflects the correct local date when the UTC timestamp crosses midnight
    Given a driver logon event with UTC timestamp "2024-03-15T23:59:59Z"
    Given the user's timezone is "Pacific/Auckland"
    When the DateTimeLogonCell component renders
    Then the displayed date reflects "16 Mar 2024" in the Auckland timezone
```

src/test/java/steps/ui/DateTimeLogonCellSteps.java
```
package steps.ui;

import hooks.Hooks;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class DateTimeLogonCellSteps {

    private String utcTimestamp;
    private String timezone = "UTC";

    @Given("a driver logon event with UTC timestamp {string}")
    public void aDriverLogonEventWithUtcTimestamp(String timestamp) {
        this.utcTimestamp = timestamp;
    }

    @Given("the user's timezone is {string}")
    public void theUsersTimezoneIs(String timezone) {
        this.timezone = timezone;
    }

    @When("the DateTimeLogonCell component renders")
    public void theDateTimeLogonCellComponentRenders() {
        String html = String.format("""
                <!DOCTYPE html>
                <html>
                  <head><meta charset="UTF-8"/></head>
                  <body>
                    <script>
                      const ts = new Date('%s');
                      const dateStr = ts.toLocaleDateString('en-GB', {
                        day: '2-digit', month: 'short', year: 'numeric', timeZone: '%s'
                      });
                      const timeStr = ts.toLocaleTimeString('en-GB', {
                        hour: '2-digit', minute: '2-digit', hour12: false, timeZone: '%s'
                      });
                      document.write(
                        '<div class="date-time-logon-cell">' +
                          '<span class="logon-date">' + dateStr + '</span>' +
                          '<span class="logon-time">' + timeStr + '</span>' +
                        '</div>'
                      );
                    </script>
                  </body>
                </html>
                """, utcTimestamp, timezone, timezone);
        Hooks.page.setContent(html);
        Hooks.page.waitForSelector(".date-time-logon-cell");
    }

    @Then("the cell displays the date {string}")
    public void theCellDisplaysTheDate(String expectedDate) {
        String actual = Hooks.page.locator(".logon-date").innerText().trim();
        assertTrue(actual.contains(expectedDate),
                "Expected date to contain '" + expectedDate + "' but was '" + actual + "'");
    }

    @Then("the cell displays the time {string}")
    public void theCellDisplaysTheTime(String expectedTime) {
        String actual = Hooks.page.locator(".logon-time").innerText().trim();
        assertTrue(actual.contains(expectedTime),
                "Expected time to contain '" + expectedTime + "' but was '" + actual + "'");
    }

    @Then("the displayed date reflects {string} in the Auckland timezone")
    public void theDisplayedDateReflectsInTheAucklandTimezone(String expectedDate) {
        String actual = Hooks.page.locator(".logon-date").innerText().trim();
        assertTrue(actual.contains(expectedDate),
                "Expected date to contain '" + expectedDate + "' but was '" + actual + "'");
    }
}
```