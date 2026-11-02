-- Visual-only native street decoration, not a transport/reservation lane.
function data()
 return {
  availability={yearFrom=0,yearTo=0},
  cost={price=0,priceScale=1}, maintenance={runningCosts=0},
  desc={name=_("LR_FENCE_NAME"),description=_("LR_FENCE_DESC"),
   icon="::/infrastructure/street/tram/tram_new.tga",
   previewIcon="::/infrastructure/street/tram/tram_new_preview.tga"},
  categoryList={categories={"lightrail_fence"}},
  menuCategory={categories={}}, order=0,
  builderAudioRes="::/gui/construction/sound/tool_edge_noise_barrier.builder_audio",
  repModel="mrnickert_ultimate_metro::/lightrail_fence.mdl",
  length=1.6,stretch=true,verticalAlignment="Shear",offset=0.15,
  snapMode="Side",skipSameInParallelStrip=true,
  incompatibleTags={"tunnel"},
  modifiers={maxSpeedModifier=0,noiseModifier=0,pollutionModifier=0},
  preventParcels=false,
 }
end
