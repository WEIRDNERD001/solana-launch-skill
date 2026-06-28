# Curated Resources (Source-of-Truth First)

> Launchpad parameters, fees, and thresholds change often. Treat these as the canonical sources to re-verify any specific number before quoting it to a user.

## Token Standards & Mint
- [SPL Token program](https://spl.solana.com/token)
- [Token Extensions (Token-2022) overview](https://solana.com/docs/tokens/extensions)
- [Token Extensions solutions page](https://solana.com/solutions/token-extensions)
- [Metadata Pointer & Token Metadata](https://solana.com/docs/tokens/extensions/metadata)
- [Neodyme: Token-2022 footguns](https://neodyme.io/en/blog/token-2022/) — read before enabling extensions
- [RareSkills: Token-2022 specification](https://rareskills.io/post/token-2022)
- [Helius: find mint/freeze/update authority](https://www.helius.dev/docs/orb/explore-authorities)

## Vesting, Lockups & Airdrops
- [Streamflow](https://streamflow.finance/) — vesting, locks, airdrops, staking
- [Streamflow: token locks in 2026](https://streamflow.finance/blog/token-locks-in-2026)
- [Streamflow: everything you need to launch a token on Solana in 2026](https://streamflow.finance/blog/everything-you-need-to-launch-a-token-on-solana-in-2026)
- [Streamflow token locks product](https://streamflow.finance/token-locks)
- [Jupiter Lock](https://lock.jup.ag/) — open-source token locks

## Liquidity & Launchpads
### Meteora
- [Meteora docs](https://docs.meteora.ag/)
- [What is Dynamic Bonding Curve (DBC)](https://docs.meteora.ag/overview/products/dbc/what-is-dbc)
- [DBC bonding curve formula](https://docs.meteora.ag/product-overview/dynamic-bonding-curve-dbc-overview/bonding-curve-formula)
- [DBC SDK](https://docs.meteora.ag/integration/dynamic-bonding-curve-dbc-integration/dbc-sdk)
- [Launchpad template](https://docs.meteora.ag/integration/dynamic-bonding-curve-dbc-integration/launchpad-template)
- [MeteoraAg/dynamic-bonding-curve (program)](https://github.com/MeteoraAg/dynamic-bonding-curve)
- [MeteoraAg/meteora-invent (launch tooling)](https://github.com/MeteoraAg/meteora-invent)

### Raydium
- [Raydium docs](https://docs.raydium.io/raydium)
- [LaunchLab](https://docs.raydium.io/raydium/launchlab/launchlab)
- [Creating a token (LaunchLab)](https://docs.raydium.io/raydium/launchlab/for-creators/creating-a-token)
- [LaunchLab & CPMM fee reference](https://docs.raydium.io/raydium/build/tips-and-gotchas/launchlab-and-cpmm-fee-reference)

### Jupiter
- [Jupiter Studio](https://jup.ag/studio)
- [What is Jupiter Studio (Backpack Learn)](https://learn.backpack.exchange/articles/what-is-jupiter-studio)

### Others
- [pump.fun](https://pump.fun/) / PumpSwap — pure memecoin fair launch

## Treasury, Multisig & Governance
- [Squads](https://squads.so/) — multisig / treasury
- [Realms](https://www.realms.today/) — on-chain governance / DAOs

## Analytics & Due Diligence
- [Solscan](https://solscan.io/) / [Solana Explorer](https://explorer.solana.com/) — verify mint, authorities, holders, LP
- Kit data MCPs (Nansen, DexPaprika, Noesis, Pyth) — holder analysis, prices, sybil clustering

## Sibling Skills (delegate to these)
- [solana-dev-skill](https://github.com/solana-foundation/solana-dev-skill) — core programs/clients/testing (this skill extends it)
- [crypto-legal-skill](https://github.com/solanabr/crypto-legal-skill) — securities, compliance, incorporation, stablecoin regs
- [position-manager-skill](https://github.com/solanabr/position-manager-skill) — CLMM/LP management after launch
- [solana-auditor-skill](https://github.com/solanabr/solana-auditor-skill) — program / transfer-hook audits
- Kit `token-2022.md`, Jupiter & Meteora skills — SDK-level execution

## Reference Launches (study the disclosures)
- BONK — 55% to airdrop; team ~20% over 3-year linear vest (Streamflow)
- Jupiter (JUP) — phased unlocks after single-date cliffs caused sell pressure; a lesson in unlock design
- Heavenland (HTO) — 97% of supply on a 5-year linear vest with cliffs
