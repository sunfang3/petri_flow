# Dependency Upgrade Spec (Iteration 7)

Last updated: 2026-04-17

## 1. Scope

This spec covers **Phase 7 / test baseline rebuild**.

Included:
- Replace placeholder-only tests with executable smoke/behavior checks.
- Add focused model tests for:
  - workflow structural validation baseline
  - case state transition baseline through case commands
- Add focused `Wf::Lola` tests for command execution + JSON parse boundaries.
- Keep runtime behavior unchanged; only compatibility-level code adjustments are allowed when required to run tests.

Excluded:
- Dependency upgrades (runtime or tooling).
- LoLA runtime integration redesign (handled in Phase 9).
- Major workflow behavior refactors.

## 2. Files in Scope

- `test/models/wf/wf_test.rb`
- `test/models/wf/lola_test.rb` (new)
- `test/models/wf/case_command_start_case_test.rb` (new)
- `test/controllers/wf/workflows_controller_test.rb`
- `test/integration/navigation_test.rb`
- `app/models/wf/place.rb`
- `app/models/wf/field.rb`
- `app/models/wf/arc.rb`
- `app/models/wf/transition.rb`
- `app/models/wf/case.rb`
- `app/models/wf/token.rb`
- `app/models/wf/workitem.rb`
- `docs/dependency-upgrade-plan.md`
- `docs/dependency-upgrade-spec-iteration7.md`

## 3. Requirements

### R1: Placeholder Reduction

- Core test entry points above must contain executable assertions (not commented placeholders).

### R2: Core Behavior Coverage

- Add tests proving:
  - invalid workflow structure is detected by `do_validate!`
  - minimal valid workflow structure is accepted
  - case start flow reaches expected states/tokens on minimal workflow net

### R3: LoLA Boundary Coverage

- Add tests for `Wf::Lola` command path that verify:
  - JSON output is parsed correctly when command output file is valid JSON
  - parse failure is surfaced when JSON output is malformed

### R4: Validation

- Run full test suite via:
  - `RAILS_ENV=test bundle exec rails test`

## 4. Known Risks

- Existing fixtures are mostly placeholder `{}` data; new tests should build isolated records explicitly.
- Graph rendering and callback hooks can make controller tests brittle if they depend on non-smoke pages.

## 5. Execution Results (2026-04-17)

- Placeholder replacement completed:
  - `test/models/wf/wf_test.rb` now verifies invalid/valid workflow structural validation outcomes.
  - `test/models/wf/case_command_start_case_test.rb` added for user/automatic transition case start behavior.
  - `test/models/wf/lola_test.rb` added for command execution and JSON parse boundary behavior.
  - `test/controllers/wf/workflows_controller_test.rb` now covers index/create(create fail)/destroy smoke paths.
  - `test/integration/navigation_test.rb` now verifies engine root routing and page rendering.
- Blocker found and fixed during execution:
  - Rails 8.1 rejected legacy enum declaration style (`enum foo: { ... }`) when loading core models.
  - Updated core workflow models to compatible form (`enum :foo, { ... }`) without behavior change.
- Validation passed:
  - `RAILS_ENV=test bundle exec rails test test/models/wf/wf_test.rb test/models/wf/case_command_start_case_test.rb test/models/wf/lola_test.rb test/controllers/wf/workflows_controller_test.rb test/integration/navigation_test.rb`
  - `RAILS_ENV=test bundle exec rails test`
