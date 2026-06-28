---
name: solana-launch
description: Safe token launch and tokenomics for Solana. Takes a founder from token design to a live, trustworthy market — supply and vesting design, SPL vs Token-2022 mint configuration, on-chain vesting and airdrops (Streamflow, Jupiter Lock), liquidity launch (Meteora DBC/DAMM v2, Raydium LaunchLab, Jupiter Studio, pump.fun), an anti-rug launch-safety gate, and post-launch operations. Use for "how should I structure my token", "how do I launch fairly without rugging my community", "design a vesting schedule", "which launchpad", "is this token safe", "lock my liquidity", or "set up my airdrop". Extends solana-dev-skill; delegates mint internals to token-2022, program audits to the auditor skill, liquidity management to the position-manager skill, and regulatory questions to the crypto-legal skill.
user-invocable: true
---

# Solana Token Launch & Tokenomics Skill

> **Extends**: [solana-dev-skill](https://github.com/solana-foundation/solana-dev-skill) — core Solana programs, clients, testing, security.

Launching a token is the highest-stakes, least-reversible thing most Solana founders do. Mint authority left live, freeze authority forgotten, LP unlocked, team unlocked at TGE, the wrong launchpad — each is a one-way door that loses trust, listings, or the whole raise. This skill is the safety rail: it routes a founder from **design → mint → distribution → liquidity → live market → operations**, baking anti-rug guarantees into every step.

It is also a **due-diligence lens**: point it at *any* mint and it will tell you whether the token is structurally safe to buy, list, or integrate.

## What This Skill Is For

Use this skill when the user asks for:

### Tokenomics Design
- Supply, allocations, and the allocation table
- Vesting schedules (cliffs, linear, price-based), unlock cliffs and sell-pressure modeling
- Emission/inflation schedules, sinks and sources, FDV vs circulating supply
- Liquidity sizing relative to FDV

### Token Creation
- SPL Token vs Token-2022 (Token Extensions) decision
- Which extensions to enable (transfer fee, metadata, transfer hook, permanent delegate — and which are footguns)
- Decimals, metadata, and authority configuration

### Distribution & Vesting
- On-chain vesting and lockups (Streamflow, Jupiter Lock)
- Airdrops at scale (Merkle/claim, sybil resistance, vested airdrops)
- Team / investor / treasury lockups with public proof links

### Liquidity Launch
- Choosing a launch venue (bonding curve vs direct liquidity vs LBP-style)
- Meteora DBC / DAMM v2 / DLMM / Alpha Vault
- Raydium LaunchLab / CPMM
- Jupiter Studio, pump.fun / PumpSwap
- LP locking / burning and migration mechanics

### Launch Safety (Anti-Rug)
- Authority management (revoke vs multisig vs keep)
- Pre-launch readiness gate
- Rug-risk / honeypot audit of a token you did NOT create

### Post-Launch Operations
- Claiming LP/trading fees, treasury management, monitoring unlocks
- Market making, CEX-listing readiness, buyback/burn, governance

### Delegate to Other Skills
- **Mint instruction internals / Token-2022 program details** → kit `token-2022.md` (or solana-dev token references)
- **Custom on-chain program / transfer-hook audit** → [solana-auditor-skill](https://github.com/solanabr/solana-auditor-skill)
- **CLMM/LP position management after launch** → [position-manager-skill](https://github.com/solanabr/position-manager-skill)
- **Securities/compliance/incorporation/stablecoin law** → [crypto-legal-skill](https://github.com/solanabr/crypto-legal-skill)
- **Swap routing / price** → kit Jupiter skill

## Golden Rules (Non-Negotiable)

1. **Every authority is a separate one-way door.** On Solana there is no single "renounce". Decide, per authority, on a deliberate timeline: keep → multisig → revoke. (See [launch-safety.md](launch-safety.md).)
2. **Vest in public.** Team/investor allocations belong in on-chain vesting with a shareable proof link *before* TGE, not a promise in a Notion doc.
3. **Lock the liquidity.** Unlocked LP is the single biggest rug vector. Lock or burn it, and prove it.
4. **Model the unlock cliffs.** A TGE that looks fine collapses at the first cliff. Chart circulating supply over time before you publish.
5. **Token-2022 extensions are immutable.** They are set at mint init and cannot be changed later. Permanent delegate and transfer hook are backdoors unless justified and audited.
6. **Never** generate or run a launch that you cannot make safe. If the user wants mint authority live + LP unlocked + no vesting, name it a rug and stop.

## Default Stack (2026)

| Layer | Default choice | When |
|-------|----------------|------|
| Token standard | **SPL Token** | Plain fungible token, max wallet/DEX compatibility |
| Token standard | **Token-2022** | Need transfer fee, on-chain metadata, confidential transfer, or soulbound |
| Fair launch (no treasury) | **Meteora DBC** or **Raydium LaunchLab** | On-chain price discovery, auto-graduation to a locked pool |
| No-code project launch | **Jupiter Studio (Custom mode)** | Want vesting + anti-sniper + auto-listing without building |
| Direct liquidity (have treasury) | **Meteora DAMM v2** / DLMM, **Raydium CPMM** | Established project seeding its own pool |
| Anti-bot fair sale | **Meteora Alpha Vault** | Whitelist/pro-rata sale before open trading |
| Vesting & lockups | **Streamflow** (default), **Jupiter Lock** | Team, investors, LP, airdrop unlocks |
| Airdrops | **Streamflow** airdrops (Merkle claim) | Up to ~1M recipients, vested/clawback options |
| Treasury custody | **Squads** multisig | Hold authorities and funds safely |

> Versions/parameters move fast. Confirm current launchpad parameters against [resources.md](resources.md) before quoting exact numbers to a user.

## Operating Procedure

### 1. Classify the request

| The user is asking about... | Start here |
|-----------------------------|-----------|
| Supply / allocations / vesting / emissions | [tokenomics-design.md](tokenomics-design.md) |
| SPL vs Token-2022, extensions, decimals, authorities | [token-mint.md](token-mint.md) |
| Vesting, lockups, airdrops, claim flows | [distribution-vesting.md](distribution-vesting.md) |
| Which launchpad / liquidity / LP locking | [liquidity-launch.md](liquidity-launch.md) |
| "Is this safe?" / revoke authorities / honeypot check | [launch-safety.md](launch-safety.md) |
| "Am I ready to launch?" (the gate) | [launch-readiness.md](launch-readiness.md) |
| Fees, treasury, monitoring, listings, governance | [post-launch.md](post-launch.md) |
| Links, SDKs, docs | [resources.md](resources.md) |

### 2. Pick the right agent

| Task | Agent | Model |
|------|-------|-------|
| Design supply, vesting, emissions, launch strategy | tokenomics-architect | opus |
| Implement the mint, vesting, liquidity scripts | launch-engineer | sonnet |
| Audit a token (yours or someone else's) for rug risk | token-safety-auditor | opus |

### 3. Always end on the safety gate

No launch is "done" until it passes [launch-readiness.md](launch-readiness.md). For a token the user did not create, run the rug-risk audit in [launch-safety.md](launch-safety.md) instead.

## Progressive Disclosure (read only what you need)

- [tokenomics-design.md](tokenomics-design.md) — Supply, allocation tables, vesting math, emissions, sinks/sources, FDV, liquidity sizing
- [token-mint.md](token-mint.md) — SPL vs Token-2022, extensions (and footguns), decimals, metadata, authorities
- [distribution-vesting.md](distribution-vesting.md) — Streamflow, Jupiter Lock, airdrops, cliffs, multi-segment locks
- [liquidity-launch.md](liquidity-launch.md) — Meteora DBC/DAMM v2/Alpha Vault, Raydium LaunchLab, Jupiter Studio, pump.fun, LP locking
- [launch-safety.md](launch-safety.md) — Authority management, anti-rug checklist, rug/honeypot audit
- [launch-readiness.md](launch-readiness.md) — The pre-launch gate (a hard checklist)
- [post-launch.md](post-launch.md) — Fee claiming, treasury, monitoring, market making, listings, governance
- [resources.md](resources.md) — Curated, source-of-truth links

## Task Routing Guide

| User asks about... | Primary file |
|--------------------|--------------|
| "How big should my supply be?" | tokenomics-design.md |
| "Design a vesting schedule for my team/investors" | tokenomics-design.md → distribution-vesting.md |
| "Should I use Token-2022?" | token-mint.md |
| "Add a 1% transfer fee / tax" | token-mint.md |
| "Create my token / set decimals" | token-mint.md |
| "Set up an airdrop for 50k wallets" | distribution-vesting.md |
| "Lock my team tokens with a proof link" | distribution-vesting.md |
| "Which launchpad should I use?" | liquidity-launch.md |
| "Launch a fair-launch memecoin" | liquidity-launch.md |
| "Seed liquidity for my project token" | liquidity-launch.md |
| "Lock / burn my LP" | liquidity-launch.md |
| "Revoke mint and freeze authority" | launch-safety.md |
| "Is this token a honeypot / rug?" | launch-safety.md |
| "Am I ready to launch?" | launch-readiness.md |
| "Claim my trading fees" | post-launch.md |
| "Manage my LP position after launch" | post-launch.md → **position-manager-skill** |
| "Is my token a security?" | **crypto-legal-skill** |
| "Audit my transfer-hook program" | **solana-auditor-skill** |

## Commands

| Command | Description |
|---------|-------------|
| /design-tokenomics | Generate a full tokenomics doc: allocations, vesting, emissions, liquidity, with an unlock-schedule model |
| /launch-checklist | Run the pre-launch readiness gate against the project and report pass/fail |
| /audit-token-safety | Rug-risk / honeypot audit of any mint by address (authorities, LP, holders, extensions) |
| /quick-commit | Quick conventional commit |

## Agents

| Agent | Purpose |
|-------|---------|
| **tokenomics-architect** | Supply, vesting, emissions, launch strategy, the tokenomics doc |
| **launch-engineer** | Implement mint, vesting, airdrop, and liquidity scripts |
| **token-safety-auditor** | Anti-rug audit of any token (authorities, LP, holders, extensions) |
