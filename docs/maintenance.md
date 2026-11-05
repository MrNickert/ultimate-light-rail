# Station maintenance

Ultimate Light Rail balances its own underground stations. The standalone Underground Lightrail Rebalance mod remains responsible for the vanilla Underground Stop; neither mod requires the other.

## Construction and the public API

The underground builder uses a maintenance base of **30,000**, matching the rebalanced vanilla stop. At the previously tested settings this corresponds to **$180,000 per year**. The base value is not a literal yearly UI price; game settings control the displayed amount.

Both through and terminus stations use this base, for every supported platform length. The shared API v1 builder also gives new third-party underground designs this base automatically. Underground construction cost remains 900,000 in builder units. Elevated stations use 120% of the surface maintenance base (24,000 versus 20,000), for both station types and all lengths. Construction prices are unchanged.

## Existing bundled stations

A one-time saved game script selects player-owned bundled underground stations with exactly the old maintenance base of 180,000 and updates it to 30,000. It also updates player-owned bundled elevated stations from 20,000 to 24,000 when their stored placement is Elevated. It recognises the configurable station only when its stored placement is Underground; the legacy underground-terminus resource is also supported. Native stored construction parameters are read through `params_native:find`.

Already adjusted stations, custom values, other owners, vanilla stations, surface stations and unrelated mod resources are skipped. Existing third-party constructions are not migrated solely because they use the API; their identity and custom maintenance are not assumed to match the bundled stations.

The script submits no reconstruction proposal and changes no geometry, terminals, connections or lines. It retains accrued charges, verifies each callback-free maintenance command on a subsequent update, and saves progress. Reloading does not compound the reduction. Missing command support or failed verification stops processing and logs a warning instead of repeatedly submitting commands. Only positive simulation time advances the migration.

The adjusted value persists in a saved game; the migration does not refund previously paid maintenance or automatically reverse changes. Keep the original save backup if a rollback is needed.

## Verification

Automated coverage checks stored native parameters, scope, ownership, exact baseline matching, retained construction/accrual data, saved pending verification, repeated loads and failures. Station-output comparisons assert the new raw underground and elevated values and normalize only that approved field when comparing historical geometry/function hashes. Historical baseline files are not rewritten.

Before publication, verify a newly built and an existing underground station in-game, allow the simulation to finish migration, then save and reload. Check existing and new Elevated stations against the Surface maintenance rate. Short progress messages use `[ULR maintenance]` in the regular game log.
