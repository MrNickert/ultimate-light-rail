"""Validate and package the current mod. Does not modify game files or saves."""
from pathlib import Path
import hashlib
import json
import re
import zipfile

ROOT = Path(__file__).resolve().parents[1]
VERSION = "1.2.2"
CONTENT = {
    "content/station_menu.lua",
    "content/maintenance_migration.gs.lua",
    "content/maintenance_migration.script.lua",
    "content/station_standard_kit.lua",
    "content/station_components.lua",
    "content/platform20.mdl",
    "content/platform_roof20.mdl",
    "content/station_api_v1.lua",
    "content/station_standard_design.lua",
    "content/station_layout_builder.lua",
    "content/elevated_paving.mdl",
    "content/elevated_paving.msh",
    "content/elevated_paving.msh.blob",
    "content/elevated_platform_roof.mdl",
    "content/elevated_concrete.mdl",
    "content/elevated_concrete_visual.mdl",
    "content/elevated_concrete.msh",
    "content/elevated_concrete.msh.blob",
    "content/elevated_entrance.mdl",
    "content/elevated_station_util.lua",
    "content/station_menu.script.lua",
    "content/light_rail_station.con.lua",
    "content/light_rail_station.script.lua",
    "content/station_config_util.lua",
    "content/underground_station_util.lua",
    "content/underground_levels.lua",
    "content/underground_geometry.lua",
    "content/underground_concourse_util.lua",
    "content/interchange_util.lua",
    "content/aboveground_interchange.con.lua",
    "content/aboveground_interchange.script.lua",
    "content/underground_interchange.con.lua",
    "content/underground_interchange_four_test.con.lua",
    "content/underground_interchange.script.lua",
    "content/lightrail_station_approach.street_template.lua",
    "content/ui/light_rail_station.tga",
    "content/ui/underground_interchange.tga",
    "content/ui/light_rail_station_preview.tga",
    "content/ui/lightrail_fenced.tga",
    "content/ui/lightrail_fenced_preview.tga",
    "content/lightrail_fenced.street_template.lua",
    "content/lightrail_fence.edge.lua",
    "content/lightrail_fence.mdl",
    "content/twin_terminus.con.lua",
    "content/through_station.con.lua",
    "content/through_station.script.lua",
    "content/through_station_util.lua",
    "content/station_turnback_track.lua",
    "content/passenger_underpass_util.lua",
    "content/passenger_crossing_util.lua",
    "content/surface_underpass.mdl",
    "content/twin_terminus.script.lua",
    "content/lightrail_double.street_template.lua",
    "content/terminus_util.lua",
    "content/surface_station_util.lua",
    "content/surface_platform.mdl",
    "content/surface_head_tile.mdl",
    "content/tram_ribbon.mdl",
    "content/tram_paving.mdl",
    "content/tram_ribbon.msh",
    "content/tram_ribbon.msh.blob",
    "content/underground_entrance_util.lua",
    "content/underground_terminus.con.lua",
    "content/underground_terminus.script.lua",
    "content/ui/metro_terminus.tga",
    "content/ui/metro_terminus_preview.tga",
    "content/ui/metro_underground_terminus.tga",
    "content/ui/metro_underground_terminus_preview.tga",
}
CONTENT.update({"content/gui/"+name for name in (
    "ui_bridge.lua","additive_bar.lua","additive_construction.lua","additive_line_filter.lua","catalog.lua","replacement.res.lua","replacement.script.lua","stations_category.res.lua",
    "native_bar.lua","native_bar.css.lua","native_construction.lua","native_construction.css.lua",
    "light_rail.tga","light_rail_line_filter.tga","build_manifest.json")})
FILES = sorted(CONTENT | {"mod.json", "strings.json", "credits.txt", "_metadata/modinfo.json", "_metadata/0.png", "_metadata/1.png", "_metadata/2.png", "_metadata/3.png", "_metadata/4.png", "_metadata/description.html"})

mod = json.loads((ROOT / "mod.json").read_text(encoding="utf-8"))
info = json.loads((ROOT / "_metadata/modinfo.json").read_text(encoding="utf-8"))
strings = json.loads((ROOT / "strings.json").read_text(encoding="utf-8"))
assert mod["modId"] == "mrnickert_ultimate_metro"
assert mod["severityRemove"] == "Critical"
assert "runScript" not in mod and "postRunScript" not in mod
assert len(info["name"]) <= 32 and len(info["summary"]) <= 100
actual = {p.relative_to(ROOT).as_posix() for p in (ROOT / "content").rglob("*") if p.is_file()}
assert actual == CONTENT, f"Unexpected or missing runtime files: {actual ^ CONTENT}"

payload = {}
keys = set()
for name in FILES:
    data = (ROOT / name).read_bytes()
    assert not data.startswith(b"\xef\xbb\xbf"), f"UTF-8 BOM: {name}"
    text = "" if name.endswith((".tga", ".blob", ".png")) else data.decode("utf-8")
    assert name == name.lower() and " " not in name
    if name.endswith((".lua", ".mdl", ".msh")):
        assert name.startswith("content/gui/native_") or name == "content/maintenance_migration.script.lua" or ("api.cmd" not in text and "addModifier" not in text)
        assert not name.endswith(".gs.lua") or name == "content/maintenance_migration.gs.lua", "Only the explicit maintenance migration may run automatically"
        if not name.startswith("content/gui/native_"): keys.update(re.findall(r'_\("([^"]+)"\)', text))
        for resource in re.findall(re.escape(mod["modId"]) + r"::/([a-z0-9_./]+)", text):
            assert (f"content/{resource}" if resource.endswith((".lua", ".tga", ".mdl", ".msh")) else f"content/{resource}.lua") in CONTENT, f"Missing local dependency: {resource}"
    payload[name] = data
for language in ("en", "nl"):
    assert set(strings[language]) == keys, f"Missing or unused strings for {language}"

out = ROOT / "dist" / f"ultimate-light-rail-{VERSION}.zip"
out.parent.mkdir(exist_ok=True)
with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as archive:
    for name, data in payload.items():
        archive.writestr(mod["modId"] + "/" + name, data)
with zipfile.ZipFile(out) as archive:
    assert archive.testzip() is None
    assert set(archive.namelist()) == {mod["modId"] + "/" + name for name in FILES}
print(out)
print("SHA256:", hashlib.sha256(out.read_bytes()).hexdigest())
print(f"{len(FILES)} files verified; complete local dependencies and localization; one explicit maintenance migration; no simulation diagnostic scripts")
