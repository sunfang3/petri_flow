# Dependency Upgrade Spec (Iteration 12)

Last updated: 2026-04-18

## 1. Scope

This spec covers **remaining placeholder test replacement** under Phase 7 hardening.

Included:

- replace remaining placeholder controller/model tests with executable assertions.
- add shared test factory helpers to reduce duplicated setup.
- fix dummy app `Field` enum declaration for Rails 8 compatible syntax (`enum :field_type, ...`) required by new test execution paths.

Excluded:

- high-risk dependency execution tracks (Bootstrap 5 / mini_racer+libv8 / rgl).
- CI workflow restructuring beyond already completed Node runtime mitigation.

## 2. Files in Scope

- `test/test_helper.rb`
- `test/controllers/wf/*_controller_test.rb` (remaining placeholder files)
- `test/models/wf/*_test.rb` (remaining placeholder files)
- `test/dummy/app/models/field.rb`
- `docs/dependency-upgrade-plan.md`
- `docs/dependency-upgrade-spec-iteration12.md`

## 3. Requirements

### R1: Placeholder Elimination

- all remaining placeholder tests in targeted controller/model files must be replaced by executable tests.

### R2: Behavioral Coverage

- controller tests should execute real request paths and assert status/redirect and key side effects.
- model tests should assert associations/callback behavior/type casting or model constraints relevant to each class.

### R3: Validation

- full test suite passes on project baseline runtime (`ruby 3.2.9`).
- no placeholder marker (`assert true`, commented `the truth`) remains in `test/controllers/wf` and `test/models/wf`.

## 4. Known Risks

- new tests currently exercise broad smoke/behavior checks and do not yet cover deeper edge conditions for every command path.
- dummy app compatibility fix (`test/dummy/app/models/field.rb`) is minimal and scoped to enum API migration.

## 5. Execution Results (2026-04-18)

- Replaced remaining placeholders across targeted controller/model tests.
- Added `WfTestFactory` in `test/test_helper.rb` for consistent workflow/user/form/workitem fixtureless setup.
- Updated dummy model enum syntax:
  - `test/dummy/app/models/field.rb`: `enum field_type: ... -> enum :field_type, ...`
- Validation:
  - `mise exec ruby@3.2.9 -- bundle exec rails test` passed.
  - Result summary: `54 runs, 173 assertions, 0 failures, 0 errors, 0 skips`.
  - Placeholder scan command returned clean:
    - `rg -n "#\s*test \"the truth\"|assert true|TODO|pending|skip" test/controllers/wf test/models/wf`
