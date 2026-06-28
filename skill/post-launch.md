# Post-Launch Operations

> TGE is the start, not the finish. Fees to claim, treasury to secure, unlocks to manage, liquidity to maintain, and a market to keep healthy.

Covers **fee claiming, treasury, monitoring, market making, listings, and governance** after the token is live. For active CLMM/LP position management, delegate to [position-manager-skill](https://github.com/solanabr/position-manager-skill).

---

## 1. Claim your fees

Most launchpads route trading fees back to the creator — but you have to claim them, and the mechanism differs:

- **Meteora DBC / DAMM v2** — after graduation, LP is locked for partner + creator, both of whom claim fees from the locked position on Meteora. DAMM v2 also offers a **compounding fee mode** that reinvests fees into the position instead of paying them out.
- **Raydium LaunchLab (Burn & Earn)** — the creator holds a **Fee Key NFT** and can earn ~10% of trading fees; claim against that NFT.
- **Jupiter Studio** — creator earns a share of swap fees and gains LP ownership after the lock period.

Set a recurring reminder to claim; document which wallet/NFT controls the claim, and keep it in the multisig.

## 2. Secure the treasury (Squads multisig)

The treasury, unrevoked authorities, fee-claim keys/NFTs, and unsold allocations should live in a **Squads multisig**, never a personal wallet:
- Define signers and a threshold (e.g. 3-of-5) appropriate to the team.
- Use spending limits / time-locks for routine outflows.
- Record the multisig address publicly so the community can watch the treasury.
- Any authority you chose to *keep* (e.g. emission mint authority) belongs here.

## 3. Monitor unlocks & supply

The dump everyone front-runs is the cliff nobody charted. From your tokenomics model:
- Track each upcoming **vesting cliff / large unlock** and communicate it ahead of time (the JUP lesson: phase big unlocks instead of single-date floods).
- Watch circulating supply vs the published schedule; reconcile any discrepancy immediately (a mismatch destroys trust).
- Monitor large holder movements (route on-chain analytics through the kit's data MCPs — Nansen, etc.).

## 4. Liquidity maintenance

- For constant-product pools (DAMM v2 / CPMM), liquidity is mostly passive — deepen it over time as volume grows.
- For **concentrated liquidity** (DLMM / CLMM), positions go out of range and need rebalancing and impermanent-loss tracking → hand off to [position-manager-skill](https://github.com/solanabr/position-manager-skill).
- Consider extending or topping up LP locks as confidence grows; publish updated proofs.

## 5. Market making (optional, disclose if used)

- Healthy two-sided liquidity reduces spread and slippage. If you engage a market maker, **disclose loan/option terms** (the JUP "MM loans" line items are a transparency model) — undisclosed MM allocations read as hidden supply.
- Never use treasury to wash-trade volume; it's deceptive and, in many jurisdictions, illegal → [crypto-legal-skill](https://github.com/solanabr/crypto-legal-skill).

## 6. CEX / aggregator listing readiness

Listing desks and DEX trust scores check for exactly the safety properties this skill enforces:
- **Revoked mint and freeze authority** (the most common hard requirement).
- Locked/burned LP with verifiable proof.
- On-chain vesting for insiders.
- Clean, durable metadata and a public tokenomics page.
- No undisclosed transfer fee / permanent delegate / transfer hook.

If you passed [launch-readiness.md](launch-readiness.md), you're most of the way there. Prepare a one-page "token safety" summary with all proof links for listing applications.

## 7. Governance (if applicable)

- For DAO-governed tokens, stand up governance (e.g. Realms) and migrate treasury/authority control to it over time.
- Define quorum, proposal thresholds, and what's on-chain vs off-chain (signal) — only valuable, contestable decisions need to be on-chain.

## 8. Buyback / burn (optional supply management)

- A buyback-and-burn or fee-funded burn is a sink that can offset emissions — but it must be **funded by real revenue**, transparent, and on a published cadence. A burn paid from treasury reserves is just a transfer with marketing.

## Post-launch checklist
- [ ] Fee-claim mechanism identified and the claim key/NFT in the multisig
- [ ] Treasury in a Squads multisig with documented signers/threshold/limits
- [ ] Upcoming unlock/cliff calendar maintained and communicated
- [ ] Circulating supply reconciled against the published schedule
- [ ] Concentrated-liquidity positions monitored (→ position-manager-skill)
- [ ] Any market-making arrangement disclosed
- [ ] Token-safety one-pager ready for listing applications
- [ ] Governance / treasury-control roadmap defined (if a DAO token)
