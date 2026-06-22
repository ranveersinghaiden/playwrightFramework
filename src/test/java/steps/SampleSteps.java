package steps;

import hooks.Hooks;
import io.cucumber.java.en.*;

public class SampleSteps {

    @Given("I open Google")
    public void openGoogle() {
        Hooks.page.navigate("https://www.google.com");
    }

    @When("I search for {string}")
    public void search(String query) {
        Hooks.page.fill("input[name=q]", query);
        Hooks.page.keyboard().press("Enter");
    }

    @Then("results should be visible")
    public void resultsVisible() {
        Hooks.page.waitForSelector("h3");
    }
}
