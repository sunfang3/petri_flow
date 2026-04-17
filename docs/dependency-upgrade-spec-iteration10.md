# Dependency Upgrade Spec (Iteration 10)

Last updated: 2026-04-18

## 1. Scope

This spec covers **Phase 10 / high-risk upgrade research**.

Included:

- produce migration proposals for:
  - `bootstrap 4 -> 5`
  - `mini_racer/libv8-node` major-line refresh
  - `rgl` refresh
- define risk matrix, sequencing, and rollback strategy.

Excluded:

- executing high-risk dependency upgrades.
- mixing this phase with unrelated CI/lint/test implementation work.

## 2. Files in Scope

- `docs/dependency-upgrade-high-risk-research.md` (new)
- `docs/dependency-upgrade-plan.md`
- `docs/dependency-upgrade-spec-iteration10.md`

## 3. Requirements

### R1: Risk Matrix

- Must classify track-level risk and identify concrete blast radius.

### R2: Migration/Rollback Proposal

- Each track must include:
  - proposed migration path
  - explicit rollback path
  - validation gates

### R3: Source Validation

- Latest upstream version claims must be backed by primary sources (official docs / gem sources).

## 4. Known Risks

- Upstream project release cadence can change after this research snapshot.
- Practical migration effort remains uncertain until implementation PRs run against full CI.

## 5. Execution Results (2026-04-18)

- Added consolidated research doc:
  - `docs/dependency-upgrade-high-risk-research.md`
- Covered required tracks:
  - Bootstrap migration risks and expected local breakage areas
  - mini_racer/libv8-node runtime jump risks
  - rgl API/runtime verification risk
- Added sequencing recommendation and per-track rollback strategy.
- Verified upstream snapshots from primary sources (RubyGems + official project docs/changelogs).
