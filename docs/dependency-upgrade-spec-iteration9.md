# Dependency Upgrade Spec (Iteration 9)

Last updated: 2026-04-17

## 1. Scope

This spec covers **Phase 9 / LoLA integration hardening**.

Included:
- Add explicit configurable LoLA binary path support.
- Improve LoLA command execution reliability/error clarity.
- Add a diagnostic rake task for LoLA environment readiness.
- Document LoLA setup and diagnostics for macOS/Linux.

Excluded:
- LoLA algorithm/analysis behavior changes.
- Rails/runtime dependency upgrades.

## 2. Files in Scope

- `lib/wf.rb`
- `app/models/wf/lola.rb`
- `lib/tasks/wf_tasks.rake`
- `test/models/wf/lola_test.rb`
- `docs/lola-integration.md` (new)
- `README.md`
- `docs/dependency-upgrade-plan.md`
- `docs/dependency-upgrade-spec-iteration9.md`

## 3. Requirements

### R1: Binary Path Resolution

- LoLA command resolution order must be explicit and deterministic:
  1. `WF_LOLA_BIN` env var
  2. app-level config (`Wf` setting)
  3. bundled build output (`tmp/lola-prefix/bin/lola`) when executable
  4. fallback command name `lola` from `PATH`

### R2: Diagnostic Task

- Provide runnable task (`app:wf:lola:doctor`) that prints:
  - resolved binary and candidate sources
  - executable availability status
  - practical next-step hints when unavailable

### R3: Validation

- Run targeted LoLA tests and full suite:
  - `RAILS_ENV=test bundle exec rails test test/models/wf/lola_test.rb`
  - `RAILS_ENV=test bundle exec rake app:wf:lola:doctor`
  - `RAILS_ENV=test bundle exec rails test`

## 4. Known Risks

- Diagnostics can verify binary availability but cannot guarantee every net/formula will be accepted by upstream LoLA.
- Host-level compile/toolchain differences still affect `rake app:wf` build outcomes.

## 5. Execution Results (2026-04-17)

- LoLA binary resolution hardening implemented:
  - added `Wf.lola_bin` configuration entry.
  - `Wf::Lola` now resolves binary in deterministic order:
    1. `WF_LOLA_BIN`
    2. `Wf.lola_bin`
    3. bundled `tmp/lola-prefix/bin/lola` (if executable)
    4. fallback `lola` in `PATH`
- LoLA execution robustness improved:
  - switched LoLA invocation to argument-array `system(*cmd)` style.
  - explicit failure raised when command execution/json output is missing.
  - failure message now points to `bundle exec rake app:wf:lola:doctor`.
- Diagnostic task added:
  - `bundle exec rake app:wf:lola:doctor` prints env/config/bundled/resolved state and readiness result.
- Test coverage expanded:
  - `test/models/wf/lola_test.rb` now covers env/config precedence for binary resolution.
  - existing LoLA command/json parse boundary tests updated for new invocation form.
- Documentation added:
  - `docs/lola-integration.md` with setup, override options, diagnostics, and troubleshooting.
- Validation passed:
  - `RAILS_ENV=test bundle exec rails test test/models/wf/lola_test.rb`
  - `RAILS_ENV=test bundle exec rake app:wf:lola:doctor`
  - `RAILS_ENV=test bundle exec rails test`
