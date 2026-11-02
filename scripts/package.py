"""Validate and package the current mod. Does not modify game files or saves."""
from pathlib import Path
import hashlib
import json
import re
import zipfile

ROOT = Path(__file__).resolve().parents[1]
VERSION = "0.8.6"
CONTENT = {
    "content/twin_terminus.con.lua",
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
FILES = sorted(CONTENT | {"mod.json", "strings.json", "credits.txt", "_metadata/modinfo.json"})

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
    text = "" if name.endswith((".tga", ".blob")) else data.decode("utf-8")
    assert name == name.lower() and " " not in name
    if name.endswith((".lua", ".mdl", ".msh")):
        assert "api.cmd" not in text and "addModifier" not in text
        assert not name.endswith(".gs.lua"), "No automatic diagnostic scripts in the clean build"
        keys.update(re.findall(r'_\("([^"]+)"\)', text))
        for resource in re.findall(re.escape(mod["modId"]) + r"::/([a-z0-9_./]+)", text):
            assert (f"content/{resource}" if resource.endswith((".lua", ".tga", ".mdl", ".msh")) else f"content/{resource}.lua") in CONTENT, f"Missing local dependency: {resource}"
    payload[name] = data
for language in ("en", "nl"):
    assert set(strings[language]) == keys, f"Missing or unused strings for {language}"

out = ROOT / "dist" / f"ultimate-metro-{VERSION}-clean.zip"
out.parent.mkdir(exist_ok=True)
with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as archive:
    for name, data in payload.items():
        archive.writestr(mod["modId"] + "/" + name, data)
with zipfile.ZipFile(out) as archive:
    assert archive.testzip() is None
    assert set(archive.namelist()) == {mod["modId"] + "/" + name for name in FILES}
print(out)
print("SHA256:", hashlib.sha256(out.read_bytes()).hexdigest())
print(f"{len(FILES)} files verified; complete local dependencies and localization; no diagnostic hooks")
