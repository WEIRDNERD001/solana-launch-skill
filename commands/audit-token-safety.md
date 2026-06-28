---
description: "Audit any Solana mint for rug/honeypot risk: authorities, Token-2022 extensions, LP lock status, holder distribution"
---

You are auditing a Solana token for **rug/honeypot risk** by mint address — the user's own token pre-launch, or a token they're about to buy, list, or integrate. Use the **token-safety-auditor** approach and be conservative: never call a token safe on incomplete data.

## Related Skills
- [launch-safety.md](../skill/launch-safety.md) §4 — the red-flag rubric and report format (your primary reference)
- [token-mint.md](../skill/token-mint.md) — Token-2022 extension footguns

## Inputs
- `mint` (required) — the token mint address
- `cluster` (default mainnet) / `rpc` (override for rate limits)

## Step 1: Read the mint
```bash
RPC="${RPC:-https://api.mainnet-beta.solana.com}"
MINT="<mint>"
curl -s -X POST "$RPC" -H "Content-Type: application/json" -d "$(cat <<EOF
{"jsonrpc":"2.0","id":1,"method":"getAccountInfo","params":["$MINT",{"encoding":"jsonParsed"}]}
EOF
)" | jq '.result.value | {owner, data: .data.parsed.info}'
```
- `owner` tells you SPL (`Tokenkeg...`) vs Token-2022 (`TokenzQd...`).
- Read `mintAuthority` and `freezeAuthority` — `null` means revoked.
- For Token-2022, inspect `data.parsed.info.extensions`: flag `permanentDelegate`, `transferHook`, `transferFeeConfig` (and whether its authority is live), `defaultAccountState: frozen`, `confidentialTransferMint`.

## Step 2: Holder distribution
```bash
curl -s -X POST "$RPC" -H "Content-Type: application/json" -d "$(cat <<EOF
{"jsonrpc":"2.0","id":1,"method":"getTokenLargestAccounts","params":["$MINT"]}
EOF
)" | jq '.result.value'
```
For each top holder, determine whether it's a **vesting/lock contract or pool** (acceptable concentration) vs a **raw wallet** (dump risk). Use an explorer / data MCP to label addresses.

## Step 3: Liquidity
Find the pool(s) for the mint and check the **LP token's** status: burned (sent to incinerator), locked (lock contract + unlock date + proof), or **unlocked** (critical red flag). Use an explorer and the venue (Meteora/Raydium) UI/API.

## Step 4: Score & report
Apply the rubric in [launch-safety.md](../skill/launch-safety.md) §4 and output its report format:
```
## Token safety audit: <symbol> (<mint>)
Verdict: SAFE | CAUTION | UNSAFE — <one line>
### Authorities … ### Liquidity … ### Holder distribution … ### Critical red flags … ### Verdict & reasoning
```

## Guardrails
- Any single critical red flag (live freeze, live mint on non-stablecoin/non-emission, permanent delegate, unaudited transfer hook, unlocked LP) ⇒ **not SAFE** absent a verified justification.
- Distinguish intent: live mint/freeze is correct for a disclosed stablecoin, a rug primitive for a community token.
- Unverifiable LP/authority state = treat as risk, state it explicitly.
- Transfer-hook/custom program needing code review → [solana-auditor-skill](https://github.com/solanabr/solana-auditor-skill). "Is it a security?" → [crypto-legal-skill](https://github.com/solanabr/crypto-legal-skill).
- Report structural facts; do not give financial advice.
