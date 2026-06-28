# Distribution & Vesting

> Where the tokens go, and how slowly. On-chain vesting with public proof links is the difference between "trust us" and "verify us."

Covers **vesting/lockups (Streamflow, Jupiter Lock), airdrops at scale, cliffs, and lock structures.** Read [tokenomics-design.md](tokenomics-design.md) first for *how much* to vest; this file is *how* to lock and distribute it.

---

## 1. Why on-chain vesting (not a spreadsheet)

A promise to vest is worthless to a buyer. An on-chain vesting contract with a shareable proof link is a cryptographic guarantee that team/investor tokens can't dump at TGE. It is now table stakes — DEX trust scores, listing desks, and informed communities check for it.

Every human-held allocation (team, investors, advisors) and often the airdrop and LP **should be locked on-chain before TGE.**

## 2. Tooling

### Streamflow (default)
Solana-native token-operations platform; listed in the official Solana docs as a vesting reference. Covers the full lifecycle: locks, vesting, airdrops, staking, payments. Contracts audited (FYEO, OPCODES) and verifiable on explorers.

- **Vesting**: linear and price-based, with cliffs and custom timelines, streaming automatically on-chain.
- **Locks**:
  - *Time-based* — simplest; investor lockups, LP tokens.
  - *Cliff* — full allocation unlocks at one date.
  - *Price-based* — unlock only when a price target is hit.
  - *Multi-segment* — one allocation split into tranches with different unlock dates (predictable supply steps).
- **Proof link**: every contract generates a shareable proof link — publish it.
- Setup is no-code and fast; or use the SDK for programmatic/bulk setup.

### Jupiter Lock
Open-source token-lock infrastructure with cliff + vesting schedules and a minimalist "Create Lock" UI. A clean, audited, free option — especially good if you're already in the Jupiter ecosystem (and Jupiter Studio launches use it under the hood).

**Choosing:** Streamflow for breadth (price-based locks, large airdrops, white-label, clawbacks). Jupiter Lock for simple, open-source team/LP locks. Either is credible; what matters is that the lock is real and public.

## 3. Designing the lock for each allocation

| Allocation | Recommended structure | Tool feature |
|------------|----------------------|--------------|
| Team | 12-mo cliff + 24–36-mo linear | Vesting w/ cliff |
| Investors | 6–12-mo cliff + 12–24-mo linear | Vesting w/ cliff |
| Advisors | Cliff + linear | Vesting |
| Treasury | Multisig-held; vest or DAO-gate | Lock or multisig |
| LP tokens | Time-lock (or burn) ≥ the venue minimum | Time-based lock |
| Airdrop (anti-dump) | Vested or price-based release | Vested airdrop |

> Precedent: BONK placed ~20% of supply across 22 early contributors on a 3-year linear vest via Streamflow; Heavenland vested 97% of supply over 5 years with cliffs. Long, public vests read as confidence.

## 4. Airdrops at scale

Airdrops drive distribution and decentralization (recall BONK's 55%-to-airdrop launch), but a naive instant airdrop = instant sell wall and a sybil magnet.

### Mechanics
- Use a **Merkle/claim** model (recipients claim; you don't pay to push 1M transfers). Streamflow airdrops support large recipient lists (up to ~1M addresses) with real-time claim visibility.
- **Formats**: instant, **vested** (unlocks over time), **price-based**, or **white-label** (your own branded claim site). For most projects, a *vested* airdrop blunts the dump.
- **Controls**: scheduling, cliffs, **clawbacks**, and cancellation for unclaimed allocations.

### Sybil resistance & eligibility
- Define eligibility from **on-chain behavior** (holding, usage, LP, prior interactions), not raw wallet count.
- De-dupe obvious sybil clusters (funding-source graphs, identical timing). For serious analysis, route on-chain analytics through the kit's data MCPs (Nansen, etc.).
- Cap per-wallet allocation; consider a claim deadline with clawback of unclaimed tokens to treasury.

### Dynamic-vesting incentive (advanced)
A pattern worth knowing: release a small portion immediately and gate the rest on engagement/staking (Streamflow's own $STREAM airdrop unlocked 20% immediately, with 80% distributed dynamically and up to 4× for stakers). Aligns claimants with the long term instead of farm-and-dump.

## 5. Distribution checklist

- [ ] Every human allocation locked on-chain **before** TGE
- [ ] Proof links generated and published (in docs / on the site)
- [ ] Lock structures match the tokenomics doc (amounts, cliffs, durations)
- [ ] Airdrop uses claim/Merkle (not 1M pushed transfers)
- [ ] Airdrop has anti-dump (vesting/price-based) and a sybil-resistant eligibility rule
- [ ] Unclaimed-airdrop clawback path defined
- [ ] LP lock/burn scheduled (see [liquidity-launch.md](liquidity-launch.md))
- [ ] Vesting/lock authorities held in multisig where the tool allows

> Compliance note: airdrops, especially to US persons, can have securities/tax implications. Route to [crypto-legal-skill](https://github.com/solanabr/crypto-legal-skill) before a large or geo-broad drop.
