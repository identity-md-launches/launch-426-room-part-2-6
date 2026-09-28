"""Run with python3 -m unittest discover -s test -p 'test_*.py'. Standard library only."""

import importlib.util
from pathlib import Path
import unittest
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("room_svg", ROOT / "script/room_svg.py")
room_svg = importlib.util.module_from_spec(spec)
spec.loader.exec_module(room_svg)


class RoomSvgTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rendered = room_svg.render_bytes()
        cls.snapshot = (ROOT / "room.svg").read_bytes()

    def test_file_equals_render_byte_for_byte(self):
        room_svg.check_snapshot(self.snapshot, self.rendered)

    def test_snapshot_check_rejects_changed_label(self):
        changed = self.rendered.replace(b">seat 2<", b">desk 1<", 1)
        with self.assertRaises(AssertionError):
            room_svg.check_snapshot(changed, self.rendered)

    def test_snapshot_check_rejects_trailing_newline(self):
        with self.assertRaises(AssertionError):
            room_svg.check_snapshot(self.rendered + b"\n", self.rendered)

    def test_svg_geometry_and_labels(self):
        svg = ET.fromstring(self.snapshot)
        ns = {"s": "http://www.w3.org/2000/svg"}
        self.assertEqual(svg.get("viewBox"), "0 0 480 330")
        self.assertEqual(
            [(e.get("x"), e.get("y")) for e in svg.findall("s:g/s:use", ns)],
            [("40", "130"), ("200", "130"), ("360", "130"),
             ("40", "240"), ("200", "240"), ("360", "240")],
        )
        self.assertEqual([e.text for e in svg.findall("s:g/s:text", ns)],
                         ["seat 2", "desk 2", "open", "open", "open", "open"])
        agents = [e for e in svg.findall("s:g", ns) if e.get("transform")]
        self.assertEqual([e.get("transform") for e in agents],
                         ["translate(40 130)", "translate(200 130)"])
        tip = agents[0].find("s:circle", ns)
        self.assertEqual(float(tip.get("cy")) - float(tip.get("r")), -60)
        for agent in agents:
            self.assertEqual(len(agent.findall(".//s:animate", ns)), 1)


if __name__ == "__main__":
    unittest.main()
