# Liquidity Launch

> The launchpad you choose decides how price is discovered, who gets in first, and whether your liquidity is lockable. Pick for the token, not the hype.

Covers the **launch-venue decision, the major venues (Meteora, Raydium, Jupiter Studio, pump.fun), and LP locking/burning.** For *managing* a CLMM position after launch, delegate to [position-manager-skill](https://github.com/solanabr/position-manager-skill).

> Launchpad parameters and fees change often. The numbers below are 2026-current references — re-verify exact thresholds/fees against [resources.md](resources.md) before quoting them to a user.

---

## 1. Decision: how should this token reach a market?

```
Do you have treasury capital to seed a pool up front?
├── NO  → Bonding-curve launch (buyers bootstrap liquidity, auto-graduates to a locked pool)
│        ├── Pure memecoin, instant, no vesting ........ pump.fun / Raydium LaunchLab "JustSendit"
│        ├── Fair launch + you want config control ..... Meteora DBC / Raydium LaunchLab (full)
│        └── No-code project token + vesting + listing .. Jupiter Studio (Custom mode)
└── YES → Direct liquidity (you seed and lock the pool)
         ├── Standard constant-product market .......... Meteora DAMM v2 / Raydium CPMM
         ├── Concentrated / capital-efficient ......... Meteora DLMM
         └── Anti-bot pro-rata / whitelist sale ........ Meteora Alpha Vault (over a pool)
```

Two more axes:
- **Fairness/anti-bot**: if a fair distribution matters, add an **Alpha Vault** (anti-bot deposit-before-trading) or use a venue with an **anti-sniper suite** (DAMM v2). Snipers buying the first block and dumping on your community is a launch-day failure mode.
- **Compatibility**: confirm your venue supports your token standard. DAMM v2 supports SPL **and** Token-2022; not every pool type/wallet does — verify if you used extensions.

## 2. Bonding-curve launches (no treasury)

A bonding curve sells tokens against a formula (price rises as supply sells), then **graduates**: liquidity auto-migrates into a real AMM pool and LP is locked or burned. No upfront pool needed — buyers bootstrap it.

### Meteora DBC (Dynamic Bonding Curve)
- Permissionless, fully on-chain price discovery; **no upfront treasury**.
- Configurable **multi-segment** virtual curve (up to 16 price/liquidity points) — start steep for early discovery, flatten later.
- Lifecycle: create config key → create virtual pool (trading starts) → buyers trade up the curve → migration threshold hit → **auto-graduates to DAMM v1/v2** → creator/partner claim surplus + LP positions. Meteora's migrator keepers run on mainnet.
- **Liquidity lock is enforced**: DBC configs require **≥10% of liquidity locked for ≥1 day** post-migration (via permanent lock and/or LP vesting on DAMM v2).
- Fees: the curve charges a trading fee on every trade; protocol takes a fixed **20% of the trading fee**; post-graduation LP is locked for partner + creator, who can claim fees (DAMM v2 also offers a compounding fee mode).
- Tooling: the `meteora-invent` repo / DBC SDK; Believe, Jupiter, and others route graduated liquidity into Meteora pools.

### Raydium LaunchLab
- Bonding-curve launchpad; **default graduation ≈ 85 SOL**, then auto-migrates to a Raydium **CPMM/AMMv4** pool.
- Two modes: **JustSendit** (one-click defaults) and **LaunchLab** (full control of curve, supply, vesting, fees).
- Curve types: linear / exponential / logarithmic; quote tokens SOL, jitoSOL, USDT, USDC.
- On graduation: LP tokens are **burned or locked** per policy. With **Burn & Earn**, LP is locked and the creator gets a **Fee Key NFT** that can earn ~10% of trading fees. Graduation is a permissionless tx (anyone can trigger it).
- Fees are additive across platform/creator/protocol/referral — model the total before launch.

### pump.fun / PumpSwap
- The lowest-friction memecoin launchpad: instant fair launch, mint authority set to null automatically, graduates to PumpSwap. Best for pure memecoins where the trust model is "no insiders, locked/burned LP, revoked authorities." Not appropriate for a token with team vesting or treasury.

### Jupiter Studio
- No-code launchpad (since 2025) controlling create → launch → trade, with anti-sniper protection, liquidity locking, **vesting**, and **auto-listing** on Jupiter when graduation criteria are met. Liquidity migrates and locks into a **Meteora** pool on graduation.
- Two creator modes: **Meme mode** (no creator vesting) and **Custom mode** (vest **0–80% of supply**, 6- or 12-month duration, optional cliff). Creator incentives include a share of swap fees and LP ownership after a lock period.
- Best when you want a project-grade launch (vesting + anti-sniper + listing) without building infrastructure.

## 3. Direct liquidity launches (you have treasury)

Seed and lock your own pool — for established projects or when you want full control of price/liquidity.

| Venue | Model | Notes |
|-------|-------|-------|
| **Meteora DAMM v2** | Upgraded constant-product | SPL + Token-2022, **anti-sniper suite**, fee modes (base+quote or quote-only), positions as **transferable NFTs**, built-in **liquidity locking** & vesting, single-sided launches, cheap (~0.022 SOL to create) |
| **Meteora DLMM** | Concentrated (bins) | Capital-efficient; more active management → hand off to [position-manager-skill](https://github.com/solanabr/position-manager-skill) |
| **Raydium CPMM** | Constant-product | Standard, deep ecosystem integration |

For a **fair sale on top of a pool**, attach a **Meteora Alpha Vault**: users deposit before trading opens and buy pro-rata, neutralizing front-running bots. Configure it (whitelist / pro-rata / caps) against an existing DAMM v1/v2 or DLMM pool.

## 4. LP locking & burning — non-negotiable

Unlocked LP is the #1 rug vector: the deployer pulls the paired SOL/USDC and the price goes to zero. **Never** launch with pullable LP.

Options, strongest trust signal first:
1. **Burn LP** — send LP tokens to the incinerator. Liquidity is permanent and provably unpullable. Simple, but you forfeit future fee claims and can't migrate.
2. **Time-lock LP** — lock LP (Streamflow / Jupiter Lock / venue-native lock) for a long, public duration. You retain fee claims; publish the proof link.
3. **Venue-enforced lock** — DBC/LaunchLab/Studio lock LP automatically on graduation (e.g. DBC's ≥10%-for-≥1-day minimum; LaunchLab Burn & Earn). Confirm the *amount* and *duration* meet your community's expectations — a 1-day minimum is a floor, not a goal.

Whatever you choose, **publish the proof**: the lock contract address or burn tx. "Liquidity locked" without a link is noise.

## 5. Launch-day fairness & anti-bot

- Use an **Alpha Vault** or the venue's **anti-sniper suite** so bots don't buy block 0 and dump on your community.
- Don't pre-announce the exact mint address far ahead without protection — snipers monitor for it.
- Consider a brief **trading-disabled / activation window** if the venue supports it.
- If you used Token-2022, double-check **freeze authority is revoked** before open trading or a malicious/forgotten freeze becomes a honeypot ([launch-safety.md](launch-safety.md)).

## 6. Liquidity-launch checklist

- [ ] Venue chosen via the decision tree (matches treasury + fairness + token standard)
- [ ] Token standard supported by the venue (esp. Token-2022 extensions)
- [ ] Curve / pool parameters set (and modeled against the tokenomics doc)
- [ ] Anti-bot mechanism in place (Alpha Vault / anti-sniper) if fairness matters
- [ ] LP **lock or burn** configured — amount + duration meet community expectations
- [ ] LP lock/burn **proof link or tx** ready to publish at TGE
- [ ] Fee model understood (who earns what, how to claim → [post-launch.md](post-launch.md))
- [ ] Devnet dry run where possible; verify pool + lock on an explorer before mainnet
- [ ] Freeze authority revoked before open trading
