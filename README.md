# Solana Launch Skill for Claude Code / Codex

**Safe token launch & tokenomics for Solana** — an addon skill that turns any coding agent into a token-launch expert. It takes a founder from a blank page to a live, trustworthy market: tokenomics design → mint configuration → on-chain vesting & airdrops → liquidity launch → an anti-rug readiness gate → post-launch operations. It doubles as a **due-diligence lens** that scores the rug/honeypot risk of *any* mint.

> **Extends**: [solana-dev-skill](https://github.com/solana-foundation/solana-dev-skill) — core Solana programs, clients, testing, security.

## Why this skill exists

Launching a token is the highest-stakes, least-reversible thing most Solana founders do — and the ecosystem has skills for *programs*, *DeFi*, *games*, and *debugging*, but **nothing that orchestrates a safe launch end-to-end**. Mint authority left live, freeze authority forgotten, LP unpullable-in-name-only, team unlocked at TGE, the wrong launchpad — each is a one-way door that loses trust, listings, or the whole raise.

This skill is the safety rail. It bakes anti-rug guarantees into every step and **refuses to ship a launch it can't make safe.**

```
┌──────────────────────────────────────────────────────────────────────┐
│                       solana-launch-skill (addon)                      │
│                                                                        │
│   design ──▶ mint ──▶ distribute ──▶ liquidity ──▶ GATE ──▶ operate    │
│   tokenomics  SPL/      vesting &     launchpad   readiness   fees,     │
│   & vesting   T-2022    airdrops      + LP lock    checklist  treasury  │
│   math        config    (on-chain)    (Meteora/    (anti-rug) monitor   │
│                                        Raydium/Jup)                     │
│                              │                                          │
│                              ▼ delegates                               │
│   solana-dev (core) · token-2022 · crypto-legal · position-manager ·   │
│   solana-auditor · Jupiter / Meteora                                   │
└──────────────────────────────────────────────────────────────────────┘
```

## What's included

### Skills (`skill/`)
| File | Covers |
|------|--------|
| [SKILL.md](skill/SKILL.md) | Entry point, golden rules, routing |
| [tokenomics-design.md](skill/tokenomics-design.md) | Supply, allocation tables, vesting math, emissions, FDV, liquidity sizing |
| [token-mint.md](skill/token-mint.md) | SPL vs Token-2022, extensions (and footguns), decimals, metadata, authorities |
| [distribution-vesting.md](skill/distribution-vesting.md) | Streamflow, Jupiter Lock, airdrops, cliffs, multi-segment locks |
| [liquidity-launch.md](skill/liquidity-launch.md) | Meteora DBC/DAMM v2/Alpha Vault, Raydium LaunchLab, Jupiter Studio, pump.fun, LP locking |
| [launch-safety.md](skill/launch-safety.md) | Authority playbook + rug/honeypot audit rubric |
| [launch-readiness.md](skill/launch-readiness.md) | The hard pre-launch gate |
| [post-launch.md](skill/post-launch.md) | Fee claiming, treasury, monitoring, listings, governance |
| [resources.md](skill/resources.md) | Curated, source-of-truth links |

### Agents (`agents/`)
| Agent | Model | Purpose |
|-------|-------|---------|
| **tokenomics-architect** | opus | Supply, vesting, emissions, launch strategy, the tokenomics doc |
| **launch-engineer** | sonnet | Implement mint, vesting, airdrop, and liquidity scripts (devnet first, verifiable) |
| **token-safety-auditor** | opus | Rug/honeypot audit of any mint |

### Commands (`commands/`)
| Command | Purpose |
|---------|---------|
| **/design-tokenomics** | Full tokenomics doc with a 36-month unlock model |
| **/launch-checklist** | Run the pre-launch readiness gate, report PASS/FAIL with evidence |
| **/audit-token-safety** | Rug/honeypot audit of any mint by address |
| **/quick-commit** | Conventional commit with a dated branch |

### Rules (`rules/`)
| File | Purpose |
|------|---------|
| `typescript.md` | Safety rules for launch scripts (no secrets, dynamic decimals, devnet-first, BigInt) |

## Installation

### Recommended: custom install
```bash
git clone https://github.com/PhilipFx/solana-launch-skill
cd solana-launch-skill
./install-custom.sh
```
The custom installer lets you choose a personal (`~/.claude/skills/`) or project (`./.claude/skills/`) location, skip the core skill if you already have `solana-dev-skill`, and pick where `CLAUDE.md` goes.

### Standard install (automation)
```bash
./install.sh        # interactive with defaults
./install.sh -y     # non-interactive, all defaults
```
Defaults: installs `solana-launch` + `solana-dev` to `~/.claude/skills/` and copies `CLAUDE.md` to `~/.claude/`.

## Usage examples

**Design**
```
"Design tokenomics for my DeFi project — 1B supply, team + seed investors, fair to the community"
"Build me a 36-month unlock schedule and flag any dump risk"
```
**Launch**
```
"Should I use SPL or Token-2022 for a token with a 1% transfer fee?"
"Lock my team tokens with a public proof link"
"Which launchpad for a fair-launch token with no treasury?"
"Lock my LP and give me the proof to publish"
```
**Safety**
```
"Revoke my mint and freeze authority — walk me through it"
"Am I ready to launch?"   → runs the readiness gate
"Is this token a honeypot?  <mint address>"   → rug-risk audit
```

## Default stack (2026)

| Layer | Default | When |
|-------|---------|------|
| Token standard | SPL Token | Plain fungible token |
| | Token-2022 | Transfer fee / on-chain metadata / confidential / soulbound |
| Fair launch (no treasury) | Meteora DBC · Raydium LaunchLab | On-chain price discovery → auto-locked pool |
| No-code project launch | Jupiter Studio (Custom) | Vesting + anti-sniper + auto-listing |
| Direct liquidity | Meteora DAMM v2 / DLMM · Raydium CPMM | You seed and lock the pool |
| Anti-bot sale | Meteora Alpha Vault | Pro-rata / whitelist before open trading |
| Vesting & lockups | Streamflow · Jupiter Lock | Team, investors, LP, airdrops |
| Treasury | Squads multisig | Hold authorities and funds safely |

> Launchpad parameters and fees move fast — re-verify exact numbers against [resources.md](skill/resources.md).

## How it fits the kit

This skill is a **cross-domain hub** that ties together pieces the Solana AI Kit already ships:
- **extends** `solana-dev-skill` for core dev,
- **delegates** mint internals to `token-2022`, liquidity execution to the Jupiter/Meteora skills,
- and **routes** the hard adjacent questions to the kit's seed skills: legal → [crypto-legal-skill](https://github.com/solanabr/crypto-legal-skill), post-launch LP management → [position-manager-skill](https://github.com/solanabr/position-manager-skill), program/transfer-hook audits → [solana-auditor-skill](https://github.com/solanabr/solana-auditor-skill).

Nothing here is opaque: pure markdown skills, transparent shell installers, no bundled executables, MIT licensed.

## Safety stance

This skill **will not**:
- produce a launch with live mint authority + unlocked LP + no insider vesting (a rug by construction),
- set a permanent delegate or transfer hook without disclosure and an audit path,
- call a token "safe" on unverified authority/liquidity data,
- advise revoking authorities where retention is legally required (stablecoins) — it routes to legal instead.

## Repository structure
```
solana-launch-skill/
├── CLAUDE.md
├── README.md
├── LICENSE
├── install.sh
├── install-custom.sh
├── .gitignore
├── skill/
│   ├── SKILL.md
│   ├── tokenomics-design.md
│   ├── token-mint.md
│   ├── distribution-vesting.md
│   ├── liquidity-launch.md
│   ├── launch-safety.md
│   ├── launch-readiness.md
│   ├── post-launch.md
│   └── resources.md
├── agents/
│   ├── tokenomics-architect.md
│   ├── launch-engineer.md
│   └── token-safety-auditor.md
├── commands/
│   ├── design-tokenomics.md
│   ├── launch-checklist.md
│   ├── audit-token-safety.md
│   └── quick-commit.md
└── rules/
    └── typescript.md
```

## Contributing
PRs welcome — keep facts current to the 2026 stack and source-of-truth first.
1. Fork; branch `feat/<scope>-<desc>-<DD-MM-YYYY>`
2. Make changes (keep skills progressive and token-efficient)
3. Open a PR

## License
MIT — see [LICENSE](LICENSE).

---

Built for the [Solana AI Kit](https://github.com/solanabr/solana-ai-kit). Reference shape: [solana-game-skill](https://github.com/solanabr/solana-game-skill).
