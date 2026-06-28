# Launch Readiness Gate

> The hard checklist a launch must pass before TGE. No item is optional; a "no" anywhere means **not ready**. This is what `/launch-checklist` enforces.

Run this against the project's tokenomics doc, mint config, vesting contracts, and liquidity plan. Report each item PASS / FAIL / N-A with evidence (an address, a proof link, an explorer URL). A launch is "ready" only when every applicable item is PASS.

---

## A. Tokenomics integrity
- [ ] Allocation table sums to **exactly 100%** and to the **exact minted supply**
- [ ] Insider share (team + investors + advisors) is justified for the token's trust model
- [ ] 36-month circulating-supply / emission model exists; no single cliff dumps an outsized % of float
- [ ] FDV and TGE market cap stated; unlock overhang disclosed

## B. Mint configuration
- [ ] Token standard chosen for a stated reason (SPL default; Token-2022 only for a named extension)
- [ ] Decimals chosen, documented, and read dynamically in all client code
- [ ] Every Token-2022 extension justified in one sentence
- [ ] No permanent delegate / transfer hook (or: disclosed **and** audited)
- [ ] Metadata name/symbol/uri set; image + JSON on durable storage (not a temporary URL)
- [ ] Minted supply == tokenomics doc supply (verified on explorer)

## C. Authorities (see [launch-safety.md](launch-safety.md))
- [ ] Authorities were minted to a **multisig**, not a hot key
- [ ] Mint authority revoked — or emission policy documented + authority secured
- [ ] Freeze authority revoked / never set (verified)
- [ ] Metadata update authority decision made and disclosed
- [ ] Token-2022 fee/withdraw authorities handled if applicable
- [ ] Revoke transactions are verifiable on an explorer

## D. Distribution & vesting (see [distribution-vesting.md](distribution-vesting.md))
- [ ] Team / investor / advisor allocations locked on-chain **before** TGE
- [ ] Vesting structures match the tokenomics doc (amount, cliff, duration)
- [ ] Public **proof links** generated and ready to publish
- [ ] Airdrop (if any) uses Merkle/claim, has anti-dump (vesting/price), sybil-resistant eligibility, and a clawback path

## E. Liquidity (see [liquidity-launch.md](liquidity-launch.md))
- [ ] Launch venue chosen via the decision tree; supports the token standard
- [ ] Curve/pool parameters modeled against the tokenomics doc
- [ ] LP **locked or burned**; amount + duration meet community expectations (not just the venue minimum)
- [ ] LP lock/burn **proof link or burn tx** ready to publish at TGE
- [ ] Anti-bot mechanism (Alpha Vault / anti-sniper) in place if fairness matters
- [ ] Devnet/dry-run completed where possible; pool + lock verified on explorer

## F. Operations & comms (see [post-launch.md](post-launch.md))
- [ ] Treasury secured in a multisig (Squads); signers and threshold documented
- [ ] Fee-claim mechanism understood (who claims, where)
- [ ] Monitoring set for upcoming unlock/cliff dates
- [ ] A public tokenomics page links the allocation table, vesting proofs, and LP lock proof

## G. Legal & compliance (route, don't guess)
- [ ] Securities/utility classification reviewed → [crypto-legal-skill](https://github.com/solanabr/crypto-legal-skill)
- [ ] Airdrop/geo/tax exposure reviewed for the target audience
- [ ] Entity/jurisdiction and any disclosures appropriate to the raise type

## H. Security
- [ ] Any custom on-chain program (incl. transfer hook) audited → [solana-auditor-skill](https://github.com/solanabr/solana-auditor-skill)
- [ ] Deploy/upgrade authority of any program secured (multisig) or revoked
- [ ] Mint/vesting/liquidity scripts dry-run on devnet; no plaintext keys in repo or logs

---

### Verdict template
```
## Launch readiness: <project> — <READY | NOT READY>

Blocking failures: <count>
- [FAIL] <item> — <what's missing / how to fix>
...

Warnings (non-blocking):
- [WARN] <item> — <note>

Evidence:
- Mint: <address>   Supply: <n> (<explorer>)
- Authorities: mint <revoked/...>, freeze <revoked/...>
- Vesting proofs: <links>
- LP lock/burn: <link or tx>
- Treasury multisig: <address>
```

A launch with **any blocking failure is NOT READY.** Do not soften the verdict; the entire value of this gate is that it doesn't.
