"""Build a clean private prototype package; no game files or saves are modified."""
from pathlib import Path
import hashlib
import json
import zipfile
root=Path(__file__).resolve().parents[1]
mod=json.loads((root/"mod.json").read_text(encoding="utf-8"))
info=json.loads((root/"_metadata/modinfo.json").read_text(encoding="utf-8"))
assert len(info["name"])<=32 and len(info["summary"])<=100
assert mod["modId"]=="mrnickert_ultimate_metro" and mod["severityRemove"]=="Critical"
files=["mod.json","strings.json","credits.txt","_metadata/modinfo.json","content/surface_stop.con.lua",
       "content/surface_stop.script.lua","content/crossover_stop.con.lua","content/crossover_stop.script.lua","content/test_track.street_template.lua","content/network_diagnostics.gs.lua","content/network_diagnostics.script.lua"]
assert "runScript" not in mod and "postRunScript" not in mod
outdir=root/"dist";outdir.mkdir(exist_ok=True)
out=outdir/"ultimate-metro-0.2.2-return-paths.zip"
with zipfile.ZipFile(out,"w",zipfile.ZIP_DEFLATED) as archive:
 for name in files:
  data=(root/name).read_bytes();assert not data.startswith(b"\xef\xbb\xbf");text=data.decode("utf-8")
  assert name==name.lower() and " " not in name
  if name.endswith(".lua"):
   assert "api.cmd" not in text and "addModifier" not in text
  archive.write(root/name,mod["modId"]+"/"+name)
with zipfile.ZipFile(out) as archive:assert archive.testzip() is None
print(out)
print("SHA256:",hashlib.sha256(out.read_bytes()).hexdigest())
print("11 prototype files verified; no world commands or vanilla modifiers")
