import struct
MASK=(1<<64)-1
MUL=0xc6a4a7935bd1e995
INV=pow(MUL,-1,1<<64)
SEED=16045690983977655786
def mix(v):
 v=v*MUL&MASK;v^=v>>47;return v*MUL&MASK
def unmix(v):
 v=v*INV&MASK;v^=v>>47;return v*INV&MASK
def walk(b,h,start,end):
 for (v,) in struct.iter_unpack('<Q',memoryview(b)[start:end]):h=((h^mix(v))*MUL)&MASK
 return h
def undo(b,h,start,end):
 for off in range(end-8,start-1,-8):h=((h*INV)&MASK)^mix(struct.unpack_from('<Q',b,off)[0])
 return h
def hash64(b):
 n=len(b);end=n//8*8;h=walk(b,SEED^(n*MUL&MASK),0,end)
 if end<n:h=((h^int.from_bytes(b[end:],'little'))*MUL)&MASK
 h^=h>>47;h=h*MUL&MASK;return h^(h>>47)
