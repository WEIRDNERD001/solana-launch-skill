---
description: "Run the pre-launch readiness gate against a Solana token project and report PASS/FAIL with evidence"
---

You are running the **launch readiness gate**. Go through every item in [launch-readiness.md](../skill/launch-readiness.md) against the project and report PASS / FAIL / N-A with concrete evidence (an address, a proof link, an explorer URL). A launch is "ready" only when every applicable item is PASS — do not soften a failing verdict.

## Related Skills
- [launch-readiness.md](../skill/launch-readiness.md) — the full checklist (your script)
- [launch-safety.md](../skill/launch-safety.md) — authority verification
- [tokenomics-design.md](../skill/tokenomics-design.md) / [distribution-vesting.md](../skill/distribution-vesting.md) / [liquidity-launch.md](../skill/liquidity-launch.md)

## Inputs (collect what's available)
| Input | Notes |
|-------|-------|
| `mint` | Token mint address — lets you verify authorities, supply, extensions on-chain |
| `tokenomics.md` | The design doc — to reconcile allocations/vesting against reality |
| `pool` / LP lock | Liquidity venue + LP lock/burn proof |
| `vesting proofs` | Streamflow/Jupiter Lock contract links |
| `treasury multisig` | Squads address |

If a mint exists, verify on-chain (don't trust the doc): `getMint` for supply/decimals/authorities; parse Token-2022 extensions; check the LP token's lock/burn status; classify top holders.

## Step 1: Verify on-chain facts (if mint exists)
```bash
RPC="${RPC:-https://api.mainnet-beta.solana.com}"
MINT="<mint>"
curl -s -X POST "$RPC" -H "Content-Type: application/json" -d "$(cat <<EOF
{"jsonrpc":"2.0","id":1,"method":"getAccountInfo","params":["$MINT",{"encoding":"jsonParsed"}]}
EOF
)" | jq '.result.value.data.parsed.info | {decimals, supply, mintAuthority, freezeAuthority}'
```
Read `mintAuthority`/`freezeAuthority`: `null` = revoked (good for a community token). For Token-2022, also inspect `extensions` in the parsed output (flag permanentDelegate, transferHook, transferFeeConfig).

## Step 2: Walk the checklist
Go section by section through [launch-readiness.md](../skill/launch-readiness.md): A tokenomics integrity, B mint config, C authorities, D distribution/vesting, E liquidity, F operations, G legal (route), H security. Mark each PASS/FAIL/N-A with evidence.

## Step 3: Report
Use the verdict template in [launch-readiness.md](../skill/launch-readiness.md):
```
## Launch readiness: <project> — <READY | NOT READY>
Blocking failures: <count>
- [FAIL] <item> — <fix>
Warnings:
- [WARN] <item> — <note>
Evidence: mint, authorities, vesting proofs, LP lock, treasury multisig
```

## Guardrails
- Any blocking failure ⇒ **NOT READY**. The gate's value is that it doesn't bend.
- Unverifiable safety property = treat as FAIL, not PASS.
- Route legal items to [crypto-legal-skill](https://github.com/solanabr/crypto-legal-skill); route program/transfer-hook audits to [solana-auditor-skill](https://github.com/solanabr/solana-auditor-skill).
