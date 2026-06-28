# Token Creation: SPL vs Token-2022

> The mint account is the most permanent thing you'll create. Decimals, the token standard, and every Token-2022 extension are set at initialization and **cannot be changed afterwards.** Get this right once.

This file covers the **standard decision, extensions (and their footguns), decimals, metadata, and authorities at mint time.** For the exact mint instructions and program internals, delegate to the kit's `token-2022.md` / solana-dev token references — this file is the *decision and configuration* layer.

---

## 1. SPL Token vs Token-2022

| | **SPL Token** (`TokenkegQ...`) | **Token-2022 / Token Extensions** (`TokenzQd...`) |
|---|---|---|
| Use when | Plain fungible token, maximum compatibility | You need transfer fee, on-chain metadata, confidential transfer, soulbound, etc. |
| Wallet/DEX support | Universal | Broad (Phantom, Backpack, Solflare) but verify each integration |
| Metadata | Separate Metaplex metadata account | Can live **on the mint** via metadata extension (fewer accounts, cheaper) |
| Extensibility | None | Rich, but **immutable once set** |
| Audits | Battle-tested | Token-2022 program audited 5× (Halborn, Zellic, NCC, Trail of Bits, OtterSec) |

**Default: SPL Token.** Choose Token-2022 only when a specific extension earns its place. Every extension you add is surface area a wallet, DEX, or integrator might not support, and risk a buyer must trust.

## 2. Token-2022 Extensions: the good, the situational, and the footguns

Extensions are enabled at mint init. Compute account size with `getMintLen([...extensions])` (extensions increase rent).

### Generally safe / useful
- **Metadata + Metadata Pointer** — name, symbol, URI, and custom fields directly on the mint. Cleaner than a separate Metaplex account.
- **Transfer Fee** — protocol-level fee on every transfer (e.g. `transferFeeBasisPoints: 100` = 1%, with a `maxFee`). Fees accrue as "withheld" and are harvested by the withdraw authority. Great for tax/royalty tokens — but disclose it loudly; a hidden tax reads as a scam.
- **Interest-Bearing** — display a rebasing balance (display only; does not mint).
- **Default Account State** — new token accounts start frozen (KYC/whitelist tokens) — *intentional* friction, used by regulated issuers.

### Footguns — require justification + audit, and are red flags to buyers
- **Permanent Delegate** — a key that can transfer or burn *anyone's* tokens, forever. This is a backdoor. Legitimate only for specific regulated/clawback use cases, and it must be disclosed. On a "community" token it is a rug primitive.
- **Transfer Hook** — calls a custom program on every transfer. Powerful (royalties, allowlists) but the hook program can block transfers (honeypot) or carry bugs. **If a token has a transfer hook, the hook program must be audited** ([solana-auditor-skill](https://github.com/solanabr/solana-auditor-skill)).
- **Non-Transferable (soulbound)** — tokens can't move. Correct for credentials/badges, fatal for a tradeable token. Note: **incompatible with Transfer Fee** (conflicting behaviors).
- **Confidential Transfer** — hides amounts. Strong privacy, but breaks naive indexers/analytics and may raise compliance questions — route to [crypto-legal-skill](https://github.com/solanabr/crypto-legal-skill).

> **Rule:** If you cannot explain, in one sentence, why a buyer should be comfortable with an extension, do not enable it.

## 3. Decimals

- Standard for a new fungible token: **6 or 9**. SOL = 9, USDC = 6.
- Memecoins sometimes use fewer; NFTs use 0.
- **Immutable.** Choose deliberately and document it.
- Client code must **always** read `getMint().decimals` — never hardcode.

## 4. Metadata

- **SPL Token** → Metaplex Token Metadata (separate account, has an `update_authority`).
- **Token-2022** → metadata extension on the mint (also has an `update_authority`).

Provide: `name`, `symbol`, `uri` (pointing to off-chain JSON with image + description). Host the JSON and image on durable storage (Arweave/IPFS/permanent CDN) — a 404'd logo on listing day is avoidable.

## 5. Authorities — set them up for the safety plan

A mint has several authorities, each a separate one-way door. Plan each one *before* mint init (full detail and the revoke flow live in [launch-safety.md](launch-safety.md)):

| Authority | Controls | Typical plan |
|-----------|----------|--------------|
| **Mint authority** | Minting new supply | Revoke for fixed supply; keep (program/multisig) only if emitting |
| **Freeze authority** | Freezing token accounts | **Revoke** (or never set) for tradeable tokens — live freeze = honeypot risk |
| **Metadata update authority** | Name/symbol/logo | Keep (multisig) for projects; revoke for memecoins |
| Transfer-fee config authority (T-2022) | Changing the fee | Revoke to lock the fee, or hold in multisig |
| Withheld-withdraw authority (T-2022) | Harvesting transfer fees | Hold in multisig; revoke = permanent auto-burn of fees |

**Best practice:** mint with authorities pointed at a **Squads multisig**, not a single hot key. Revoke (set to `null` via `SetAuthority`) once tokenomics and ops are stable. Prefer true revoke over "send to incinerator" — it's cheaper, clearer in history, and what DEX/exchange listing checks look for.

> **Stablecoin exception:** regulated issuers (Circle/Paxos-style) *retain* mint and freeze authority by necessity. That is correct for them and wrong for a community token. Know which one you are → [crypto-legal-skill](https://github.com/solanabr/crypto-legal-skill).

## 6. Mint configuration checklist

- [ ] Standard chosen (SPL default; Token-2022 only for a named reason)
- [ ] Extensions list finalized — each justified in one sentence; no unexplained permanent delegate / transfer hook
- [ ] If transfer hook present → hook program scheduled for audit
- [ ] Decimals chosen and documented (read dynamically everywhere)
- [ ] Metadata JSON + image on durable storage; name/symbol/uri set
- [ ] Authorities pointed at a multisig at init (not a hot key)
- [ ] Total minted supply == tokenomics doc supply, exactly
- [ ] `getMintLen` rent funded
- [ ] Revoke timeline written down (which authority, when) → [launch-safety.md](launch-safety.md)

Implementation note: keep the mint script idempotent and dry-runnable on devnet first; verify the resulting mint with `getMint` / a block explorer before any mainnet run. Two-strike rule: if a mint script fails twice, stop and ask.
