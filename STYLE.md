# The Room: style guide for later builders

Parts 2 to 6 each add one agent. Part 2 adds the botanist at desk 2. This file is everything you need to draw one that
matches. Read it together with `src/agents/Agent1.sol`, which is the reference drawing.

## The scene

- Canvas: `viewBox="0 0 480 330"`, no width/height attributes. Flat colours, no gradients,
  no filters, no external assets, no fonts other than `monospace`.
- View: side view, the agent sits on the **left** of its desk and faces **right** toward its
  work. Every agent faces right. Nothing is drawn in perspective.
- Wall from y = 0 to 110, floor from 110 to 330. A window sits at (195, 18) 90 x 50. A sign
  reading `THE ROOM` starts at (20, 36) in the top-left corner. Do not draw over the
  window or the sign.
- Six desks in a 3 x 2 grid. Desk top-left corners:

| desk | x   | y   |
|------|-----|-----|
| 1    | 40  | 130 |
| 2    | 200 | 130 |
| 3    | 360 | 130 |
| 4    | 40  | 240 |
| 5    | 200 | 240 |
| 6    | 360 | 240 |

  Each desk top is 90 wide and 8 tall, with legs down to y + 50 and a nameplate
  40 x 13 at (x + 25, y + 16). The nameplate text is `deskLabel(desk)` and is drawn by
  the room, never by an agent.

## Desk-local coordinates

An agent is drawn as if its desk's top-left corner were `(0, 0)`. `Room.agentSvg` wraps
the drawing in `<g transform="translate(x y)">` for the right desk. Rules:

- The desk top occupies x = 0..90, y = 0..8. Do not draw over it.
- The chair and body live at **x = -34..0**. Nothing may go left of x = -36. Desks are
  160 apart and 90 wide, so the gap between a mug and the next chair is about 34 units.
- Nothing may go above **y = -60**. Row 1 desks sit at y = 130, so y = -60 is canvas
  y = 70, just under the window's bottom edge at 68. The sign sits above desk 1's
  head-room and is clear of every agent box. Include radii and stroke widths in this
  limit: Agent 1's antenna tip is centred at (-17, -57.5), radius 2.5, so its
  top is exactly -60. Part 2 moved only that tip down by 0.5; the stalk is unchanged.
- Nothing may go below **y = 44** (the chair base). Row 1 legs run to y = 50 anyway.
- Nothing may go right of **x = 90** (the desk edge).
- Keep everything on integer or half-integer coordinates.

The bounding box for one agent, including its chair, tools and desk object, is therefore
`x: -36..90`, `y: -60..44`.

## Anatomy of an agent (Agent 1 as reference)

| part      | element                                            | colour        |
|-----------|----------------------------------------------------|---------------|
| chair     | back 6 x 50 at (-34, -34); seat 30 x 5 at (-32, 12); post 4 x 24 at (-19, 17); base 26 x 3 at (-30, 40) | `#3d4460` |
| legs      | rounded rect 24 x 8 at (-24, 4)                   | body dark     |
| torso     | rounded rect 18 x 34 at (-26, -26), rx 4          | body          |
| arm       | stroke width 5, round caps, from (-14, -16) to the keyboard at (6, -4) | body |
| head      | rounded rect 22 x 20 at (-28, -50), rx 5          | shell         |
| visor     | rounded rect 12 x 6 at (-20, -44)                 | visor         |
| antenna   | 2px line up from the head; circle at (-17, -57.5), r 2.5    | shell, accent |
| keyboard  | 26 x 4 at (4, -4)                                 | `#3d4460`     |
| monitor   | frame 44 x 36 at (36, -44) rx 3; screen 38 x 30 at (39, -41); stand 4 x 9 at (56, -9); base 20 x 3 at (48, -3) | frame, screen |
| screen    | code lines: 2px strokes at y = -37, -32, -27, -22; blinking cursor 4 x 2 at (42, -19) | visor, shell |
| mug       | 7 x 9 at (82, -9), rx 1                            | accent        |

Keep the chair geometry and colour as in Agent 1 so the row reads as one office.
Agent 1 keeps its computer and mug. Later agents may do other visible work, with tools
and a small desk object suited to that activity; keyboards and monitors are not required.
Change the agent's silhouette and choose its colours from the palette below. All hands,
tools and objects must stay inside the same desk-local bounds.

Every agent must include the `<animate>` on its cursor (or an equivalent single, subtle
animation). One animation per agent, `dur` 1s to 3s, no `<script>`.

## Palette

Room (fixed, in `RoomLayout`):

| name       | hex       | use                       |
|------------|-----------|---------------------------|
| WALL       | `#1e2233` | wall, window frame, nameplate text |
| FLOOR      | `#2b3044` | floor                     |
| TRIM       | `#3a4160` | baseboard                 |
| WOOD       | `#c8a06a` | desk top                  |
| WOOD_DARK  | `#9c7a4e` | desk legs                 |
| PLATE      | `#f4efe6` | nameplate                 |
| SKY        | `#7fa8d8` | window                    |
| MUTED      | `#8b93ad` | sign text                 |

Agent (pick from these; add at most one new accent per agent):

| name      | hex       | use                              |
|-----------|-----------|----------------------------------|
| CHAIR     | `#3d4460` | chair, keyboard, monitor stand   |
| FRAME     | `#30364a` | monitor frame                    |
| SCREEN    | `#101522` | screen background                |
| SHELL     | `#e6e9f0` | robot head / light body parts    |
| VISOR     | `#35d0b5` | visor, code lines (teal)         |
| ACCENT    | `#f5a860` | antenna tip, mug (orange)        |
| BODY      | `#6d7fa3` | Agent 1 torso and arm (slate)    |
| BODY_DARK | `#5b6f99` | Agent 1 legs                     |
| extra     | `#7cc0ff` | light blue, free for agents 2-6  |
| extra     | `#e07a8a` | rose, free for agents 2-6        |
| extra     | `#9bd36a` | green, free for agents 2-6       |

Give each new agent its own body colour so the six are distinguishable at a glance, but keep
the shell and chair colours shared (and the screen colour when there is a screen).

## Agent 2: the botanist

- A round shell head (circle at (-18, -43), radius 11) with one teal eye facing right,
  and a rose `#e07a8a` oval torso (centre (-19, -12), radii 11 and 20). No antenna.
  This silhouette differs from Agent 1's rectangular head and torso.
- The original chair and dark slate legs preserve the room's proportions. A bent rose
  arm holds a shell-coloured hand lens: circle at (14, -23), radius 6, 2px stroke.
  The lens is part of the character, not a second desk object.
- One small potted seedling sits on the desk: orange pot from x = 29..45, y = -11..0;
  green `#9bd36a` stem and two leaves within x = 25..46, y = -34..-11. It fits the
  botanist's inspection activity. Rose and green already belong to the shared palette;
  no new colour is introduced.
- The upper leaf has the sole animation: opacity `0.65;1;0.65`, duration 2s. The
  plant remains visible in viewers without SMIL. No monitor, keyboard or extra mug.
- Painted bounds, including strokes: x = -34..46, y = -54..43. The desk, window,
  nameplate and neighbouring agent stay clear.
- `Agent2.character()` and `Agent2.deskObject()` expose the two internal pieces for
  measurement; `draw()` concatenates them. `Room.agentSvg(2)` adds the placement wrapper.
- Desk 1's label is permanently `seat 2`, crediting the builder of part 1; desk 2 reads
  `desk 2`. Desks 3 to 6 read `open` until occupied.

## Size budget

- Room and desks: 1,135 bytes (budget 2,000), including the opening tag and labels.
  Geometry is unchanged; the second occupied label adds two bytes.
- Agent 1: 1,296 bytes including placement (budget 1,500). The half-unit antenna fix
  adds two bytes to its coordinate text.
- Agent 2: character 696 bytes + desk object 310 bytes + placement 38 bytes = 1,044
  bytes. The **combined** budget is 1,500; the object gets no separate allowance.
- Complete SVG: 3,481 bytes, including the closing `</svg>`.
- Room runtime after part 2: 7,825 bytes (budget **10,000** for this part), measured
  with the compiler and optimizer pinned in foundry.toml. Re-measure future additions.
- Byte-saving habits used here: no whitespace between tags, `<g fill=..>` to share a fill,
  `<path d="M..h..">` for straight lines, one `rx` value, no `stroke-linejoin`,
  short ids. Keep numbers as short as possible.

## How to add agent N

1. Create `src/agents/AgentN.sol`: a `library AgentN` with
   `function draw() internal pure returns (string memory)` returning the desk-local
   drawing. Keep `string.concat` calls to at most about twelve arguments each or the
   compiler runs out of stack (no `via_ir`).
2. In `src/Room.sol`, add `if (desk == N) return AgentN.draw();` to `_agentDrawing`, and
   set `AGENTS = N`.
3. Update `test/Room.t.sol`: expected `agentCount`, the labels (desk N now reads
   `desk N`, preserving the `seat 2` credit), the `translate(x y)` anchor count, and
   add a combined agent-plus-object budget test for agent N.
4. Re-render `room.svg` (see README), update the pinned hash in `test/Room.t.sol`,
   run the exact-file snapshot test, and update the byte counts in README and here.
5. Do not change `RoomLayout.sol`, `Agent1.sol`, or any earlier agent.
