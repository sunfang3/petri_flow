# Dependency Upgrade Plan

Last updated: 2026-04-16

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

## 6. Immediate Next Step

- Run CI on `upgrade` branch and collect any environment-specific regressions.
