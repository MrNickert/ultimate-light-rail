"""Regenerate the original rigid concrete mesh/buffer; never reads native binaries."""
from pathlib import Path
import struct,math
r=Path(__file__).resolve().parents[1]
def w(n,s):(r/n).write_text(s,encoding='utf-8',newline='\n')
faces=[
 ([(0,0,0),(6,0,0),(6,4,0),(0,4,0)],(0,0,1)),
 ([(0,4,-2.4),(6,4,-2.4),(6,0,-2.4),(0,0,-2.4)],(0,0,-1)),
 ([(0,0,-2.4),(6,0,-2.4),(6,0,0),(0,0,0)],(0,-1,0)),
 ([(6,4,-2.4),(0,4,-2.4),(0,4,0),(6,4,0)],(0,1,0)),
 ([(0,4,-2.4),(0,0,-2.4),(0,0,0),(0,4,0)],(-1,0,0)),
 ([(6,0,-2.4),(6,4,-2.4),(6,4,0),(6,0,0)],(1,0,0)),
]
pos=[];uv=[];norm=[];tang=[];indices=[]
for points,normal in faces:
 base=len(pos);pos+=points
 # A plain concrete area of the installed atlas; avoid railings/trim islands.
 uv +=[(.06,.05),(.40,.05),(.40,.85),(.06,.85)]
 norm +=[normal]*4
 delta=[points[1][k]-points[0][k] for k in range(3)]
 length=math.sqrt(sum(v*v for v in delta));tang +=[(*[v/length for v in delta],1)]*4
 indices +=[base,base+1,base+2,base,base+2,base+3]
blob=b''.join(struct.pack('<3f',*p) for p in pos)+b''.join(struct.pack('<2f',*p) for p in uv)+b''.join(struct.pack('<3f',*p) for p in norm)+b''.join(struct.pack('<4f',*p) for p in tang)
blob+=struct.pack('<36I',*indices)*4
(r/'content/elevated_concrete.msh.blob').write_bytes(blob)
w('content/elevated_concrete.msh','''-- Original rigid closed concrete box. All counts/offsets are bytes.
function data()
 return {subMeshes={{indices={position={count=144,offset=1152},uv0={count=144,offset=1296},
  normal={count=144,offset=1440},tangent={count=144,offset=1584}}}},
  vertexAttr={position={count=288,numComp=3,offset=0},uv0={count=192,numComp=2,offset=288},
   normal={count=288,numComp=3,offset=480},tangent={count=384,numComp=4,offset=768}}}
end
''')

# Original sidewalk tile, reusing the same four-vertex mesh buffer layout.
points=[(0,0,0),(3,0,0),(3,3,0),(0,3,0)]
uvs=[(0,0),(1,0),(1,1),(0,1)]
paving=b''.join(struct.pack('<3f',*p) for p in points)
paving+=b''.join(struct.pack('<2f',*p) for p in uvs)
paving+=struct.pack('<3f',0,0,1)*4+struct.pack('<4f',1,0,0,1)*4
paving+=struct.pack('<6I',0,1,2,0,2,3)*4
(r/'content/elevated_paving.msh.blob').write_bytes(paving)
w('content/elevated_paving.msh',(r/'content/tram_ribbon.msh').read_text().replace('0.5m long','3 x 3m'))
