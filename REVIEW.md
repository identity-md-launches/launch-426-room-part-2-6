# Builder verification: The Room, part 2

This section records local builder checks, not a new independent review. The historical
part 1 review follows unchanged below.

- Added only Agent2 to the existing composition: a round rose botanist using a hand lens
  beside one potted seedling. RoomLayout and all six desk positions remain unchanged.
- Desk 1 credits the part 1 builder as `seat 2`; desk 2 reads `desk 2`; desks 3–6 are open.
- Fixed the part 1 head-room discrepancy by changing only the antenna circle's cy from
  -58 to -57.5. Radius 2.5 now places its top at exactly -60. A snapshot pins the full
  resulting agent 1 drawing, and the Python test checks the tip's numeric bound.
- Read both protected launch checks. Room remains pure and storage-free, with no external
  calls, admin surface, ETH entry point or token interaction. LaunchToken and launch.json
  are byte-for-byte unchanged. The Room ABI is unchanged; no new deployment arguments.
- Budgets measured and asserted: room/desks 1,135 B <= 2,000; placed agent 2 plus plant
  1,044 B <= 1,500; Room runtime 7,825 B <= 10,000. Agent 1 is 1,296 B. The plant is
  310 B, the botanist/chair/lens 696 B, and its placement wrapper 38 B.
- `forge build`, `forge test` (38 tests, including four 256-run fuzz tests), and
  `forge fmt --check` pass with the pinned solc 0.8.26. Foundry reports existing lint
  suggestions for intentional grid division, a bounded decimal-digit cast and the
  desk-range check reached from rendering loops; compilation and tests succeed.
- Four Python tests pass: byte-for-byte comparison of the actual room.svg with the raw
  ABI output of the offline renderer; rejection of a changed label; rejection of a trailing
  newline; XML structure, desk positions, labels, head-room and animation checks. Solidity
  independently pins the render hash. Neither FFI nor Foundry filesystem access is enabled.
- The SVG is well-formed and geometry has been checked against STYLE.md. No rasterizer
  is installed in this workspace; the automated checks do not constitute a visual review.
- Sepolia remains pending a supplied RPC endpoint and signing account or deployment
  service. Local simulation is not an on-chain deployment. README documents chain ID,
  constructor parameters, launch configuration and the operator's receipt-verification work.

---

# Review: The Room, part 1

Scope: `src/Room.sol`, `src/RoomLayout.sol`, `src/agents/Agent1.sol`, `src/LaunchToken.sol`,
`script/Deploy.s.sol`, the tests, and the rendered `room.svg`. Reviewed against the brief
(value-free, deterministic, six desks, one agent, size budgets) and the launch floor
(`Project.protected.t.sol`, `Token.protected.t.sol`).

## What was re-run

```
forge build --offline                                   ok, no warnings
forge test --offline                                    35 passed, 0 failed (4 fuzz tests, 256 runs each)
forge fmt --check                                       clean
EXPECTED_CHAIN_ID=0 forge script script/Deploy.s.sol:Deploy --offline   ok, one deployment
python3 xml.dom.minidom parse of room.svg               well-formed; 6 <use>, labels desk 1 + 5x open
```

Measured: room+desks 1,133 B, agent 1,294 B, render 2,433 B, Room runtime 6,552 B,
LaunchToken runtime 1,323 B.

## Findings

1. **Sign collided with desk 2's monitor** (found during review, fixed). The wall sign was
   first centred at (240, 96); desk 2's monitor spans x 236..280, y 86..122. Moved the sign to
   (20, 36). Re-rendered and re-measured.
2. **`string.concat` with 19 arguments failed to compile** ("stack too deep"). Split into
   helpers of at most 12 arguments. STYLE.md warns later builders.
3. **Name shadowing warning** (`desk` function vs `desk` parameter). Renamed to `drawDesk`.
4. **Rejection of the previous attempt**: `src/LaunchToken.sol` was missing. The brief says
   "no token" for the Room; the launch process requires a LaunchToken regardless. Resolved by
   delivering the token as a separate contract that the Room does not reference in any way.
   Disposition: documented in README, tested in `test/LaunchToken.t.sol`.

No open findings.

## Checklist

- Access control: no state-changing functions exist on `Room`. `LaunchToken` has only the
  ERC-20 transfer/approve surface. No owner, no roles.
- Value: `Room` has no `receive`/`fallback`; sending ETH reverts (tested). No external calls,
  no `CALL`/`STATICCALL`/`DELEGATECALL`/`CALLCODE`/`SELFDESTRUCT`/`SSTORE` in Room runtime
  (tested by opcode scan that skips PUSH immediates, the same scan as the protected floor).
- Determinism: all Room functions are `pure`; two instances render byte-identical output
  (tested). No `block.*`, `msg.*`, or `tx.*` reads.
- Arithmetic: desk positions computed from `desk - 1` only after the range check, so no
  underflow path is reachable. `str()` handles 0 and any `uint256`.
- Bounds: `deskLabel`/`agentSvg` revert with `NoSuchDesk` for 0 and > 6 (unit + fuzz).
- Composition: `render() == roomSvg() + agentSvg(1) + "</svg>"` (tested), so the budgets
  measured on the parts are the budgets of the whole.
- Token floor: supply 10^27 to `msg.sender`, `decimals()` 18, exact transfer, curated admin
  selectors revert without changing supply, no forbidden opcodes. Mirrors the protected tests.
- Deploy: `run()` reads only `EXPECTED_CHAIN_ID` (via `envOr`, so an empty environment is
  fine); the guard `check()` and `deploy()` are tested directly. No key material anywhere.
- Constructor context: neither contract uses `msg.sender` for privileges. `LaunchToken` mints
  to `msg.sender`, which is the factory, as the floor requires.

## What the tests do not cover

- Visual correctness. The geometry was checked by hand (bounding boxes in STYLE.md) and the
  SVG parses, but no rasteriser was available in the sandbox to eyeball `room.svg`. A later
  builder should open it in a browser before extending the style.
- Gas of `render()` is a few hundred thousand when called in a transaction (the string
  concatenation dominates); it is meant for `eth_call`, which is free.
