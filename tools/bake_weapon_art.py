"""Bake bundled Monocraft outlines and bundled icon PNGs into geometry.

Run only to refresh art. Normal builds consume data/weapon_art.json and do not
require Pillow or fontTools. The runtime package contains finite glyph geometry.
"""
from pathlib import Path
import json
import math
from fontTools.ttLib import TTFont
from fontTools.pens.basePen import BasePen
from fontTools.pens.boundsPen import BoundsPen
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]


class OutlinePen(BasePen):
    def __init__(self, glyphs):
        super().__init__(glyphs)
        self.paths = []
        self.path = []

    def _moveTo(self, p):
        self.path = [p]

    def _lineTo(self, p):
        self.path.append(p)

    def _qCurveToOne(self, p1, p2):
        p0 = self._getCurrentPoint()
        bend = math.hypot(p0[0]-2*p1[0]+p2[0], p0[1]-2*p1[1]+p2[1])
        n = max(2, min(32, math.ceil(math.sqrt(bend / 5))))
        for i in range(1, n+1):
            t = i/n
            self.path.append(((1-t)**2*p0[0]+2*t*(1-t)*p1[0]+t*t*p2[0],
                              (1-t)**2*p0[1]+2*t*(1-t)*p1[1]+t*t*p2[1]))

    def _curveToOne(self, p1, p2, p3):
        p0 = self._getCurrentPoint()
        for i in range(1, 25):
            t = i/24
            self.path.append(tuple((1-t)**3*p0[k]+3*t*(1-t)**2*p1[k]+3*t*t*(1-t)*p2[k]+t**3*p3[k] for k in (0, 1)))

    def _closePath(self):
        if len(self.path)>2:
            self.paths.append(self.path)
        self.path = []

    _endPath = _closePath


def fill_paths(paths, scale):
    """Even/odd horizontal decomposition preserves counters (0, 8, R, ...)."""
    ys = sorted({p[1] for contour in paths for p in contour})
    edges = [(a,b) for contour in paths for a,b in zip(contour, contour[1:]+contour[:1]) if a[1]!=b[1]]
    tris = []
    def x_at(edge, y):
        a,b = edge
        return a[0]+(b[0]-a[0])*(y-a[1])/(b[1]-a[1])
    for lo,hi in zip(ys, ys[1:]):
        mid = (lo+hi)/2
        active = [e for e in edges if min(e[0][1],e[1][1])<=mid<max(e[0][1],e[1][1])]
        active.sort(key=lambda e:x_at(e,mid))
        assert len(active)%2==0
        for left,right in zip(active[::2],active[1::2]):
            a,b,c,d = (x_at(left,lo),lo),(x_at(right,lo),lo),(x_at(left,hi),hi),(x_at(right,hi),hi)
            for t in [(a,b,c),(b,d,c)]:
                area=abs((t[1][0]-t[0][0])*(t[2][1]-t[0][1])-(t[1][1]-t[0][1])*(t[2][0]-t[0][0]))
                if area>1e-5:
                    tris.append([round(v/scale,6) for p in t for v in p])
    return tris


def icon_spans(image):
    # Original mode art stores the white face in R and an edge mask in B.
    # Preserve face coverage; provide our own dark shadow in the renderer.
    red=image.convert('RGB').getchannel('R')
    box=red.point(lambda v:255 if v>16 else 0).getbbox()
    assert box
    x0,y0,x1,y1=box
    width,height=x1-x0,y1-y0
    rects=[];open_runs={}
    for y in range(y0,y1):
        runs={};x=x0
        while x<x1:
            a=int((red.getpixel((x,y))+21)//43)*43
            a=min(255,a)
            if not a:x+=1;continue
            first=x;x+=1
            while x<x1 and min(255,int((red.getpixel((x,y))+21)//43)*43)==a:x+=1
            key=(first,x,a)
            if key in open_runs:
                i=open_runs[key];rects[i][3]+=1
            else:
                i=len(rects);rects.append([first-x0,y-y0,x-first,1,a])
            runs[key]=i
        open_runs=runs
    # Common normalized visual height, actual shape aspect retained.
    return {'aspect':width/height,'rects':[[round(x/height,6),round((height-y-h)/height,6),round(w/height,6),round(h/height,6),a] for x,y,w,h,a in rects]}


def main():
    font=TTFont(ROOT/'third_party/monocraft/Monocraft.ttf')
    glyphs=font.getGlyphSet();cmap=font.getBestCmap()
    bounds=BoundsPen(glyphs);glyphs[cmap[ord('H')]].draw(bounds)
    cap=bounds.bounds[3]-bounds.bounds[1]
    chars='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ /%.-+'
    baked={}
    for ch in chars:
        name=cmap[ord(ch)];pen=OutlinePen(glyphs);glyphs[name].draw(pen)
        baked[ch]={'advance':round(font['hmtx'][name][0]/cap,6),'triangles':fill_paths(pen.paths,cap)}
    presentation=json.loads((ROOT/'data/weapon_presentation.json').read_text(encoding='utf-8'))
    icons={}
    for label,spec in presentation['icons'].items():
        name=spec['path'].rsplit('/',1)[-1]
        icons[label]=icon_spans(Image.open(ROOT/'assets/weapon_icons'/f'{name}.png'))
    data={'font':'Monocraft','font_program_embedded':False,'glyphs':baked,'icons':icons}
    (ROOT/'data/weapon_art.json').write_text(json.dumps(data,separators=(',',':'))+'\n',encoding='utf-8')
    print('Baked',len(baked),'Monocraft glyphs and',len(icons),'bundled mode icons;',sum(len(x['triangles'])for x in baked.values()),'font triangles')


if __name__=='__main__':
    main()
