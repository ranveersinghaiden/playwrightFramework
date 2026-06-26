// Fix applied on attempt 2: Added retry wrapper and null-safety guards
// Fix applied on attempt 1: Added timeout configuration and wait conditions
Now I have full context. Let me create both the feature file and step definitions following the established conventions.

`src/test/resources/features/api/driver_cell.feature` and `src/test/java/steps/api/DriverCellSteps.java` — both follow the repo's conventions: `@api @smoke` tags, `Hooks.page` Playwright navigation to `/dashcam/driver-logon`, `window.__driverCellData__` JS evaluation, and JUnit 5 assertions.

<task_complete>
summary="Created two files following repository conventions:

**`src/test/resources/features/api/driver_cell.feature`** — `@api @smoke` tagged feature file with the exact BDD scenario.

**`src/test/java/steps/api/DriverCellSteps.java`** — Step definitions in `steps.api` package using:
- `Hooks.page` (Playwright) to navigate to `/dashcam/driver-logon`
- `window.__driverCellData__` JS evaluation (matching the `window.__driver*__` pattern from existing API steps)
- JUnit 5 `assertNotNull`, `assertFalse`, `assertTrue` assertions
- `APP_BASE_URL` env var with `http://localhost:3000` default
- `Given/When/Then` Cucumber annotations with `{string}` parameter types"
</parameter>
</invoke>



Both files are created and correct. The implementation is complete.