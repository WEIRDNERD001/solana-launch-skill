# Tokenomics Design

> Design the token before you mint it. The mint is permanent; the spreadsheet is not.

This file covers **supply, allocations, vesting, emissions, sinks/sources, FDV, and liquidity sizing**. The output is a tokenomics document (see `/design-tokenomics`) that every later step — mint config, vesting setup, launchpad choice — reads from.

---

## 1. Supply

Total supply is a branding/UX choice, not an economic one — `supply × price = market cap` regardless of the number. Pick for clarity, then never change it.

| Total supply | Feel / precedent | Notes |
|--------------|------------------|-------|
| 1,000,000,000 (1B) | The Solana default (BONK-era, most launchpads) | Clean unit price, room for "low price per token" psychology |
| 100,000,000 (100M) | Mid, "serious project" | Used by many DeFi tokens |
| 21,000,000 | Scarcity narrative (BTC homage) | Higher unit price |
| 10,000,000,000+ | Memecoin / "trillions of tokens" | Beware integer overflow in math; fine on-chain (u64) |

**Decimals are separate from supply.** SOL uses 9, USDC uses 6. For a new fungible token, **6 or 9** is standard. More decimals = finer granularity but larger numbers. Whatever you choose, the on-chain raw amount is `display_amount × 10^decimals`. Pick decimals at mint init — it is immutable.

> **Footgun:** Hardcoding decimals client-side. Always read `getMint().decimals`. A token with 6 decimals where you assumed 9 is off by 1000×.

## 2. The Allocation Table

This is the heart of tokenomics. Every allocation needs: **%, token amount, unlock schedule, and purpose.** A table a reader can audit in 30 seconds beats a paragraph.

Template (adjust to the project — these are illustrative, not prescriptive):

| Allocation | % | Tokens (of 1B) | Unlock | Purpose |
|------------|---|----------------|--------|---------|
| Liquidity | 15–40% | 150–400M | Locked at TGE | Seed the market; LP locked/burned |
| Community / Airdrop | 10–55% | 100–550M | Instant or vested | Distribution, users, incentives |
| Team | 10–20% | 100–200M | **12-mo cliff + 24–36-mo linear** | Builders |
| Investors | 10–25% | 100–250M | 6–12-mo cliff + 12–24-mo linear | Seed/strategic |
| Treasury / Ecosystem | 10–30% | 100–300M | Multisig, vest or DAO-gated | Grants, partnerships, runway |
| Advisors | 1–5% | 10–50M | Cliff + linear | Aligned helpers |

Rules of thumb:
- **Sum to exactly 100%** and exactly the minted supply. The audit checks this.
- **Insiders (team + investors + advisors) should not exceed ~40–50%** for a community-credible launch; lower is better for memecoins (BONK put 55% to airdrop, ~20% team).
- **Liquidity is not "free float"** — it is locked capital. Don't double-count it as circulating.
- Every line with humans behind it (team, investors, advisors) **must** be vested on-chain (see [distribution-vesting.md](distribution-vesting.md)).

## 3. Vesting & Cliffs

Vesting aligns insiders with long-term holders and prevents a TGE dump.

- **Cliff**: nothing unlocks until date X, then a chunk releases at once. A 12-month cliff means zero team tokens for a year.
- **Linear vesting**: tokens stream continuously (per-second on Solana) after the cliff.
- **Price-based**: unlock gated on a price target instead of (or with) time — Streamflow supports this.
- **Multi-segment**: a single allocation split into tranches with different unlock dates for predictable supply steps.

Standard, credible insider schedule: **12-month cliff, then 24–36-month linear.** Investors sometimes 6–12-month cliff. Memecoins often have no team vest at all (and instead revoke everything and lock LP) — that is a *different* trust model, not a lesser one.

> **The cliff trap:** A big chunk unlocking on one day = a sell-pressure event the market front-runs. Prefer a cliff *followed by linear* over a pure cliff. JUP's large single-date unlocks (e.g. 253M JUP on one Feb-2026 day) are a textbook example of why even strong projects move to phased releases.

### Vesting math sanity check

For each allocation, compute monthly unlocked tokens and overlay them. The aggregate is your **emission curve** (next section). A schedule is healthy when no single month dumps more than a few % of circulating supply into the market.

## 4. Circulating Supply & Emission Schedule

**Always model circulating supply over time before publishing.** This is the single most skipped step and the source of most "why did it dump" post-mortems.

```
circulating(t) = TGE_unlocked
               + Σ(vesting unlocked by t across all allocations)
               + Σ(emissions/inflation minted by t)
```

Produce a month-by-month table (or chart) for at least 36 months. Flag every month where:
- A cliff releases > 5% of then-circulating supply, or
- Cumulative insider unlocks cross holders' (community float).

**FDV vs market cap:** Fully Diluted Valuation = `price × total supply`. A token "up only" on 3% circulating float with a 36-month unlock ahead is a different asset than its market cap suggests. State both numbers; sophisticated buyers and listing desks look at FDV and the unlock overhang.

### Inflationary tokens (staking/emissions)

If the token emits (e.g. LP/staking rewards), define:
- **Initial emission rate** and **decay** (e.g. halving, or linear taper).
- **Terminal/tail emission** (or hard cap).
- **Who** gets emissions (LPs, stakers, validators) and **why** (the behavior you're paying for).
- Whether the mint authority stays live for this (it must — see [token-mint.md](token-mint.md)) and how it's secured (program PDA or multisig, never a single hot key).

## 5. Sinks & Sources (utility tokens / game tokens)

For tokens with an in-app economy, balance is everything: `sources ≤ sinks + locked` or the token inflates to zero.

| Sources (mint/earn) | Sinks (burn/spend/lock) |
|---------------------|--------------------------|
| Rewards, emissions, airdrops, quests | Fees, purchases, upgrades, crafting |
| | Burns, staking lockups, governance escrow |

Anti-inflation levers: time-gated rewards, diminishing returns, consumable sinks, staking incentives, buyback-and-burn. (For game economies specifically, the game skill's economy patterns apply.)

## 6. Liquidity Sizing

Liquidity is what makes price real. Too little and the chart is a meme; too much and you've over-allocated capital.

- For a **bonding-curve launch** (DBC/LaunchLab), initial liquidity is bootstrapped by buyers — you don't pre-fund a pool, but you DO configure the curve and the migration threshold (e.g. Raydium LaunchLab default graduation ≈ 85 SOL → CPMM pool).
- For a **direct liquidity** launch, a rough heuristic: seed enough that a typical trade moves price < a few %. Many projects seed **2–10% of FDV** in paired value as a starting pool, then deepen over time.
- **Always lock or burn LP** (see [liquidity-launch.md](liquidity-launch.md)). Liquidity you can pull is not liquidity — it's a rug waiting to happen.

## 7. Output: the tokenomics document

`/design-tokenomics` produces `tokenomics.md` with:

1. Token basics — name, symbol, supply, decimals, standard (SPL/Token-2022), planned authorities
2. Allocation table (summing to 100% / full supply)
3. Per-allocation vesting schedule
4. A 36-month circulating-supply / emission table (with flagged cliff months)
5. FDV and TGE market cap
6. Liquidity plan (venue + size + lock)
7. Authority plan (keep/multisig/revoke per authority, with timeline)
8. Open legal questions → routed to [crypto-legal-skill](https://github.com/solanabr/crypto-legal-skill)

Hand this to the **launch-engineer** agent to implement, and gate it through [launch-readiness.md](launch-readiness.md) before TGE.
