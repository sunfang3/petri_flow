# Dependency Upgrade Plan

Last updated: 2026-04-17

## 1. Objective

Upgrade this Rails engine from the current locked baseline (`Rails 7.0.4`, historical Ruby 2.6 CI) to a currently supported stack in controlled phases, with testable checkpoints and rollback boundaries.

## 2. Constraints

- The repo is a Rails engine with a dummy host app for tests.
- Frontend stack is tightly coupled to Bootstrap 4 + jQuery + Select2 theme.
- Several dependencies are stale (`bootstrap4-kaminari-views`, `select2-rails-2020`, `loaf`, `ruby-graphviz`).
- Avoid one-shot full upgrade; keep each phase independently releasable.

## 3. Phase Plan

### Phase 1: Baseline and Toolchain

- Raise runtime/tooling baseline to modern Ruby (>= 3.2).
- Upgrade CI workflows to current GitHub Actions patterns.
- Align static analysis baseline (`.rubocop.yml`) with the new Ruby version.
- Keep application behavior unchanged.

Exit criteria:
- CI config updated and syntactically valid.
- Ruby version policy is explicit in repo metadata.

### Phase 2: Rails 7.0 -> 7.2 Track

- Upgrade Rails and compatible dependencies to latest 7.2 patch line.
- Keep Sprockets path operational for existing assets.
- Fix deprecations surfaced by test suite.

Exit criteria:
- Full test suite green on Rails 7.2.x.
- No critical deprecation warnings in test runs.

### Phase 3: Frontend Compatibility Decoupling

- Decouple from Bootstrap 4 specific helpers/themes.
- Replace `bootstrap4-kaminari-views` usage and theme calls.
- Prepare Select2 styling path that does not depend on `select2-bootstrap4`.

Exit criteria:
- Engine UI renders correctly without Bootstrap 4-only APIs.
- Pagination and Select2 behavior remains intact.

### Phase 4: Rails 8.x Upgrade

- Upgrade Rails to latest 8.x stable line.
- Resolve blockers like `annotate` AR < 8 constraint in development setup.
- Re-validate engine loading, routing, and all model/controller tests.

Exit criteria:
- Test suite green on Rails 8.x.
- CI and release workflow stable.

### Phase 5: Post-Rails8 Dependency Refresh

- Refresh low-risk direct dependencies to latest compatible releases.
- Validate on CI-targeted Ruby matrix (`3.2`, `3.3`) with DB migration + test workflow.
- Capture remaining blocked/high-risk dependencies for later dedicated migration tracks.

Exit criteria:
- Selected low-risk gems upgraded and locked.
- `app:db:* + test` passes on Ruby 3.2 and 3.3 locally.
- Residual blockers are documented with concrete reasons.

### Phase 6: CI Stabilization

- Add manual trigger support and improve CI observability.
- Split LoLA setup from DB/test execution to isolate failures.
- Inject explicit LoLA source URL and build flags in workflow.

Exit criteria:
- CI workflow supports `workflow_dispatch`.
- Matrix jobs stay deterministic and non-hanging.
- Linux CI run passes on Ruby 3.2 and 3.3 after workflow changes.

### Phase 7: Test Baseline Rebuild

- Replace commented placeholder tests with real smoke/behavior checks.
- Add model/controller/integration sanity tests for core workflow paths.
- Add focused tests around `Wf::Lola` command execution and JSON parsing boundaries.

Exit criteria:
- Meaningful test count increase (no placeholder-only suite).
- Core workflow CRUD and state transitions covered by executable tests.

### Phase 8: Mid-Risk Dependency Refresh

- Upgrade lint/tooling dependencies (`rubocop*`) as a compatible set.
- Reduce warning noise from stale dependency overlaps where feasible.
- Keep runtime behavior unchanged while modernizing development toolchain.

Exit criteria:
- Static analysis stack updated and runnable.
- No new runtime regressions introduced by tooling upgrades.

### Phase 9: LoLA Integration Hardening

- Add explicit config path support for LoLA binary (not only global `PATH`).
- Provide diagnostic task for LoLA environment readiness.
- Document Linux/macOS setup differences and fallback behavior.

Exit criteria:
- App can use LoLA reliably in environments without global install.
- Clear diagnostics and docs for operational troubleshooting.

### Phase 10: High-Risk Upgrade Research

- Evaluate migration tracks for Bootstrap 5, `mini_racer`/`libv8`, and `rgl`.
- Identify breakages, rollback points, and sequencing constraints.
- Produce specs for future dedicated execution phases.

Exit criteria:
- Written migration proposals with risk matrix and rollback strategy.
- No accidental high-risk upgrades merged without dedicated phase/spec.

## 4. Execution Rules

- One phase per change set; no cross-phase mixing.
- Every phase ends with:
  - changed files summary
  - test/validation output summary
  - known residual risk list
- If a phase cannot be validated, stop and record blocker instead of forcing forward.

## 5. Progress

- Phase 1: completed (Ruby/CI baseline aligned to current supported versions).
- Phase 2: completed (Rails upgraded to 7.2 track).
- Phase 3: completed (removed Bootstrap 4 specific pagination/select2 coupling).
- Phase 4: completed (Rails upgraded to 8.x with validation on Ruby 3.2.9).
- Phase 5: completed (low-risk dependency refresh + Ruby 3.2/3.3 matrix validation).
- Phase 6: completed (workflow stabilized; Linux matrix runs green on Ruby 3.2/3.3).
- Phase 7: completed (placeholder tests replaced by executable smoke/behavior baseline).
- Phase 8: completed (RuboCop toolchain upgraded and compatible with current config).

## 6. Immediate Next Step

- Start Phase 9 by hardening LoLA integration diagnostics and configurable binary path usage.
