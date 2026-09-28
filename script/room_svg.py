#!/usr/bin/env python3
"""Render/check room.svg offline without FFI or Foundry filesystem permissions."""

import argparse
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
SNAPSHOT = ROOT / "room.svg"


def render_bytes():
    result = subprocess.run(
        ["forge", "script", "script/Render.s.sol:Render", "--offline", "--json"],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    report = json.loads(result.stdout)
    if not report["success"]:
        raise RuntimeError("offline render failed")
    # Decode the raw ABI return, avoiding CLI display escaping or whitespace trimming.
    data = bytes.fromhex(report["returned"].removeprefix("0x"))
    offset = int.from_bytes(data[:32], "big")
    length = int.from_bytes(data[offset : offset + 32], "big")
    svg = data[offset + 32 : offset + 32 + length]
    if offset != 32 or len(svg) != length or not svg.startswith(b"<svg") or not svg.endswith(b"</svg>"):
        raise ValueError("unexpected render ABI output")
    return svg


def check_snapshot(snapshot, rendered):
    if snapshot != rendered:
        raise AssertionError("room.svg differs from Room.render(); run python3 script/room_svg.py --write")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="regenerate the SVG instead of checking it")
    args = parser.parse_args()
    rendered = render_bytes()
    if args.write:
        SNAPSHOT.write_bytes(rendered)
        print(f"Wrote {len(rendered)} bytes to room.svg (no trailing newline)")
    else:
        check_snapshot(SNAPSHOT.read_bytes(), rendered)
        print(f"room.svg equals render(): {len(rendered)} bytes")
