-- Public modular design: missing or "default" means the core's standard kit.
-- The native 40m platform/roof adapters span two logical 20m modules.
return function()
 return {apiVersion=1,id="mrnickert_standard",components={
  platform="default",shelter="default",canopy="default",trees="default",
  planters="default",benches="default",bins="default",lights="default",
 }}
end
