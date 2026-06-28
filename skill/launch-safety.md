# Launch Safety (Anti-Rug)

> On Solana there is no single "renounce ownership." A token is a bundle of separate authorities, each a one-way door. This file is the authority playbook and the rug/honeypot audit — for tokens you create **and** tokens you're asked to buy, list, or integrate.

Two modes:
- **Builder mode** — you're launching: configure authorities and liquidity so your token is provably safe.
- **Auditor mode** — you're evaluating someone else's mint: score its rug risk. (`/audit-token-safety`)

---

## 1. The authority model

| Authority | What a malicious holder can do | Default plan for a community token |
|-----------|-------------------------------|-----------------------------------|
| **Mint authority** | Mint unlimited new supply, dilute/dump | **Revoke** (fixed supply). Keep only to emit — then secure in a program PDA or multisig, never a hot key |
| **Freeze authority** | Freeze buyers' accounts so they can't sell → **honeypot** | **Revoke** (or never set). Live freeze on a tradeable token is a top red flag |
| **Metadata update authority** | Rewrite name/symbol/logo (phishing, impersonation) | Multisig for projects; **revoke** for memecoins |
| **Permanent Delegate** (T-2022) | Transfer/burn *anyone's* tokens, forever — backdoor | **Do not set** unless a disclosed, audited regulated use case |
| **Transfer Hook** (T-2022) | Block transfers / run arbitrary code on every transfer | Avoid; if present, the hook program **must be audited** |
| **Transfer-fee config authority** (T-2022) | Change the transfer fee (e.g. raise to 100%) | Revoke to lock the fee, or hold in multisig |
| **Withheld-withdraw authority** (T-2022) | Harvest accrued transfer fees | Multisig; revoking = permanent fee auto-burn |

Solana ≠ Ethereum's single `Ownable`. **Full renunciation means revoking each authority individually.** A token that revoked mint but left freeze live is *not* safe.

## 2. The keep → multisig → revoke timeline

Revocation is permanent, so sequence it:

1. **Mint with authorities pointed at a Squads multisig**, not a single key. This alone removes single-key-compromise risk and is reversible.
2. **Operate** from the multisig while tokenomics/ops stabilize.
3. **Revoke** (set authority to `null` via `SetAuthority`) once you're committed — mint and freeze first, as those carry the most rug weight and gate most listings.

Prefer **true revoke** over transferring to a burn/incinerator address: cheaper, clearer in tx history, and what DEX/exchange listing checks actually verify.

**Exceptions (don't blindly revoke):**
- **Stablecoins / regulated issuers** retain mint and freeze by law/design — correct for them, wrong for a community token. → [crypto-legal-skill](https://github.com/solanabr/crypto-legal-skill)
- **Emission/staking tokens** keep mint authority — but in a program PDA or multisig with a published policy, never a personal key.
- **Early-stage governance tokens** may hold authorities in a DAO/multisig before any revoke.

## 3. Builder-mode safety configuration

- [ ] Authorities minted to a **multisig**, not a hot key
- [ ] Mint authority revoked (or emission policy + secured authority documented)
- [ ] Freeze authority revoked / never set
- [ ] Metadata update authority decided (multisig or revoked) and disclosed
- [ ] No permanent delegate (or disclosed + audited)
- [ ] No transfer hook (or hook program audited → [solana-auditor-skill](https://github.com/solanabr/solana-auditor-skill))
- [ ] Transfer-fee config authority handled if a fee exists; fee disclosed
- [ ] Team/investor allocations vested on-chain with **public proof links**
- [ ] LP **locked or burned** with a **published proof link / burn tx**
- [ ] Minted supply == published tokenomics, exactly
- [ ] Revoke actions are themselves verifiable on an explorer

> If a user wants live mint authority **and** unlocked LP **and** no vesting, that is a rug by construction. Name it plainly and refuse to ship it.

## 4. Auditor mode — rug / honeypot risk audit of any mint

Given a mint address, gather facts (RPC `getAccountInfo` on the mint; `getTokenLargestAccounts`; the LP pool and lock contract; metadata; for Token-2022, parse the extension TLV) and score:

### Critical red flags (any one ⇒ do not buy/list/integrate without explanation)
| Signal | Why it's critical |
|--------|-------------------|
| **Freeze authority is live** | Seller's accounts can be frozen → classic honeypot (buy, can't sell) |
| **Mint authority is live** (non-stablecoin, non-emission) | Supply can be inflated and dumped at will |
| **Permanent delegate set** | Anyone's tokens can be moved/burned — a backdoor |
| **Transfer hook** present and unaudited | Transfers can be blocked or exploited |
| **LP not locked/burned** | Deployer can pull liquidity → instant zero |

### Elevated risk
| Signal | Why it matters |
|--------|----------------|
| Top 1–10 holders control most non-LP supply | Concentration → dump risk; check if those are vesting contracts vs raw wallets |
| Team/investor tokens not in a vesting contract | "Trust us" instead of cryptographic lock |
| Transfer fee present but undisclosed, or with a live config authority that can raise it | Hidden/raisable tax |
| Mutable metadata update authority on a memecoin | Logo/name can be swapped for phishing |
| Very short LP lock (e.g. only the venue minimum) | Liquidity can be pulled soon after launch |
| Confidential-transfer extension | Opaque to analytics; weigh against the use case |

### Report format
```
## Token safety audit: <symbol> (<mint>)

Verdict: SAFE | CAUTION | UNSAFE — <one line>

### Authorities
- Mint authority:   <pubkey | revoked> — <ok/red flag>
- Freeze authority: <pubkey | revoked> — <ok/red flag>
- Update authority: <pubkey | revoked> — <note>
- Token-2022 extensions: <list> — <flag permanent delegate / transfer hook / fee>

### Liquidity
- Pool(s): <venue + address>
- LP status: <burned | locked until <date> (proof: <link>) | UNLOCKED ❌>

### Holder distribution
- Top holders: <% and whether vesting contracts vs wallets>

### Critical red flags
- <list, or "none">

### Verdict & reasoning
<2–4 sentences tying findings to the verdict>
```

Be conservative: when liquidity or authority state can't be verified, say so and treat it as risk, not as pass. Never tell a user a token is safe on incomplete data.

## 5. What this skill will not do

- Will not produce a launch with live mint authority + unlocked LP + no vesting (a rug).
- Will not set a permanent delegate or transfer hook without disclosure + an audit path.
- Will not advise on revoking authorities for assets where retention is legally required (stablecoins) — routes to legal instead.
- Will not call a token "safe" without verified authority and liquidity data.
