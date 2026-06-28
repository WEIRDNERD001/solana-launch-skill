---
globs:
  - "scripts/**/*.{ts,tsx}"
  - "src/**/*.{ts,tsx}"
  - "app/**/*.{ts,tsx}"
exclude:
  - "**/node_modules/**"
  - "**/dist/**"
  - "**/*.d.ts"
---

# TypeScript Standards for Solana Launch Scripts

Rules for the mint / vesting / airdrop / liquidity client scripts this skill produces.

## Safety first (these are load-bearing for a token launch)

### Never hardcode or log secrets
```typescript
// BAD — key in source, will be committed
const payer = Keypair.fromSecretKey(Uint8Array.from([12, 34, ...]));

// GOOD — read from env/file path, never logged
import { readFileSync } from "node:fs";
const payer = Keypair.fromSecretKey(
  Uint8Array.from(JSON.parse(readFileSync(process.env.KEYPAIR_PATH!, "utf8"))),
);
```
Never `console.log` a secret key, mnemonic, or full keypair. Redact addresses only when necessary.

### Read decimals dynamically — never assume
```typescript
// BAD — assumes 9 decimals; off by 1000x on a 6-decimal token
const raw = amount * 1_000_000_000;

// GOOD — read the mint
const mint = await getMint(connection, mintAddress, "confirmed", programId);
const raw = BigInt(Math.round(amount * 10 ** mint.decimals));
```

### Use the right token program id
Pass the correct program (SPL `TOKEN_PROGRAM_ID` vs `TOKEN_2022_PROGRAM_ID`) everywhere — ATAs, transfers, mint reads. Mixing them throws `AccountOwnedByWrongProgram`.

### Devnet before mainnet; support --dry-run
Every script must run against devnet and print intended actions under `--dry-run` before any mainnet execution. Verify results with `getMint` / explorer.

### Use BigInt for token amounts
Token raw amounts are `u64`. Use `bigint`, not `number`, to avoid precision loss above 2^53.

## Type safety

### No `any`
```typescript
// BAD
function handle(info: any) { return info.value; }
// GOOD
interface MintInfo { decimals: number; supply: bigint; }
function handle(info: MintInfo): bigint { return info.supply; }
```

### Explicit return types on exported functions
```typescript
export async function createMint(/* ... */): Promise<PublicKey> { /* ... */ }
```

### Tree-shakable imports
```typescript
// BAD
import * as web3 from "@solana/web3.js";
// GOOD
import { Connection, PublicKey, Keypair } from "@solana/web3.js";
```

## SDK discovery
Before calling an SDK (Streamflow, Meteora DBC, Raydium, Jupiter Lock), verify the actual exported API in `node_modules/<pkg>/dist/*.d.ts` — do not guess method names from memory. A wrong method name on a mainnet launch script is an expensive mistake.

## Verification
After any on-chain action, fetch and assert the result (supply minted == expected, authority == null after revoke, LP lock exists). Don't trust the tx returning without confirming state at the same commitment.
