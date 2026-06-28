---
description: "Design a complete, safe tokenomics plan for a Solana token: allocations, vesting, emissions, liquidity, authorities — with a 36-month unlock model"
---

You are designing tokenomics for a Solana token. The output is a `tokenomics.md` document the team can hand to the launch-engineer and gate through the readiness checklist. Use the **tokenomics-architect** approach.

## Related Skills
- [tokenomics-design.md](../skill/tokenomics-design.md) — the method and templates
- [distribution-vesting.md](../skill/distribution-vesting.md) — lock structures
- [liquidity-launch.md](../skill/liquidity-launch.md) — venue selection
- [launch-safety.md](../skill/launch-safety.md) — authority strategy

## Step 1: Establish the trust model
Ask (or infer) the essentials before designing:
- What is the token for? (memecoin / DeFi / governance / utility / game / stablecoin)
- Is there a treasury to seed liquidity, or a no-treasury fair launch?
- Are there team/investors who need vesting, or is it insider-free?
- Target audience and jurisdiction (flags legal questions)?

A memecoin and a governance token are different designs — don't proceed until the trust model is clear.

## Step 2: Supply & basics
Choose total supply (1B is the Solana default), decimals (6 or 9), and token standard (SPL default; Token-2022 only for a named extension). Document each choice — all are immutable.

## Step 3: Allocation table
Build a table where every row has **%, token amount, unlock schedule, purpose**, summing to exactly 100% and the full supply. Keep insiders credible (≤ ~40–50%; lower for memecoins).

## Step 4: Vesting per allocation
Assign cliff + linear schedules to every human-held allocation (team 12-mo cliff + 24–36-mo linear is standard). Prefer cliff-then-linear over pure cliffs.

## Step 5: Model 36 months of circulating supply
Compute monthly unlocked tokens for each allocation, add emissions, and produce a month-by-month circulating-supply table. **Flag every month where a cliff releases an outsized % of float.** State FDV and TGE market cap and the unlock overhang.

## Step 6: Liquidity & authority plan
- Liquidity: venue (from the decision tree) + size + **lock/burn** plan.
- Authorities: per authority, choose keep / multisig / revoke on a timeline. Default community token: multisig at init → revoke mint + freeze.

## Step 7: Write `tokenomics.md`
Assemble: basics, allocation table, vesting, 36-month emission model (with flagged cliffs), FDV/MC, liquidity plan, authority plan, open legal questions (→ crypto-legal-skill). Present for approval.

## Guardrails
- Numbers, not adjectives — show monthly unlocks, FDV, float %.
- No pullable LP, no live mint/freeze for community tokens (unless an explicitly justified stablecoin/emission case).
- Surface legal questions; don't answer them.
- The design isn't done until it could pass [launch-readiness.md](../skill/launch-readiness.md).

## Output checklist
- [ ] Trust model identified
- [ ] Supply, decimals, standard chosen (with reasons)
- [ ] Allocation table sums to 100% / full supply
- [ ] Vesting per human allocation
- [ ] 36-month circulating-supply model with flagged cliffs
- [ ] FDV + TGE market cap stated
- [ ] Liquidity venue + size + lock plan
- [ ] Authority plan (keep/multisig/revoke + timeline)
- [ ] Open legal questions routed
