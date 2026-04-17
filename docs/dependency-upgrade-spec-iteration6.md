# Dependency Upgrade Spec (Iteration 6)

Last updated: 2026-04-17

## 1. Scope

This spec covers **Phase 6 / CI stabilization**.

Included:
- Add manual trigger support for CI workflow.
- Split LoLA build and test execution into separate CI steps.
- Inject explicit LoLA source URL and build flags in CI.
- Keep LoLA setup non-blocking while ensuring test phase still blocks on failures.

Excluded:
- Expanding test coverage itself (handled in next phase).
- Frontend/runtime major dependency migrations.

## 2. Files in Scope

- `.github/workflows/ci.yml`
- `docs/dependency-upgrade-plan.md`
- `docs/dependency-upgrade-spec-iteration6.md`

## 3. Requirements

### R1: Triggering and Reliability

- CI must support `workflow_dispatch`.
- CI job should have explicit timeout to avoid hanging builds.

### R2: Step Separation

- LoLA build must run in a dedicated step with:
  - `WF_LOLA_URL` set to verified mirror URL.
  - `CXXFLAGS='-std=gnu++98'`.
- DB/test execution must run in a dedicated step after LoLA step.

### R3: Validation Path

- Local verification:
  - YAML parse check for workflow file.
  - Local CI-equivalent command chain passes on Ruby `3.2.9`.
- Remote verification:
  - Push `upgrade` branch and run GitHub Actions matrix (`3.2`, `3.3`).

## 4. Known Risks

- LoLA upstream source availability still depends on external host uptime.
- CI Linux environment may compile LoLA differently from macOS but should remain non-blocking.

## 5. Execution Results (2026-04-17)

- Workflow updates applied:
  - added `workflow_dispatch`
  - split LoLA build and DB/test into separate steps
  - injected `WF_LOLA_URL` and `CXXFLAGS` for LoLA build step
  - added job timeout (`30` minutes)
  - moved OS package installation before `ruby/setup-ruby` (bundler-cache needs native deps early)
  - added `x86_64-linux` platform into `Gemfile.lock` for GitHub Actions runners
- Local validation passed:
  - `.github/workflows/ci.yml` YAML parsing succeeded
  - `RAILS_ENV=test bundle exec rake app:wf` passed
  - `RAILS_ENV=test bundle exec rails app:db:create app:db:migrate` passed
  - `RAILS_ENV=test bundle exec rails test` passed
- Remote matrix verification:
  - first push run failed at `Set up Ruby` due lockfile platform mismatch
  - fix applied: lockfile platform + CI step ordering
  - rerun passed on GitHub Actions run `24561648155` for both `ruby 3.2` and `ruby 3.3`
  - residual note: `actions/checkout@v4` shows Node 20 deprecation warning (future CI maintenance item)
