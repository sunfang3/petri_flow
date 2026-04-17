# Dependency Upgrade Spec (Iteration 11)

Last updated: 2026-04-18

## 1. Scope

This spec covers **CI Node20 deprecation mitigation**.

Included:

- update GitHub Actions checkout action to Node24 runtime line.
- validate workflow syntax and verify matrix run result.

Excluded:

- adding new lint jobs or non-deprecation CI restructuring.
- dependency upgrades unrelated to CI runtime warning mitigation.

## 2. Files in Scope

- `.github/workflows/ci.yml`
- `docs/dependency-upgrade-plan.md`
- `docs/dependency-upgrade-spec-iteration11.md`

## 3. Requirements

### R1: Action Runtime

- `actions/checkout` must move off Node20 runtime line to a Node24-compatible release.

### R2: Validation

- workflow YAML parse succeeds.
- GitHub Actions matrix run on `upgrade` completes successfully.

## 4. Known Risks

- self-hosted runners below required minimum version for newer action releases would fail; GitHub-hosted runners are expected to be compatible.

## 5. Execution Results (2026-04-18)

- In progress.
