"""Triangulate the concave mech outline at build time."""
def triangulate_polygon(points):
    def cross(a, b, c):
        return (b[0]-a[0])*(c[1]-a[1])-(b[1]-a[1])*(c[0]-a[0])
    area = sum(points[i][0]*points[(i+1)%len(points)][1]-points[(i+1)%len(points)][0]*points[i][1] for i in range(len(points)))
    sign = 1 if area > 0 else -1
    ids = list(range(len(points)))
    triangles = []
    while len(ids) > 3:
        found = False
        for j, current in enumerate(ids):
            prev, following = ids[j-1], ids[(j+1)%len(ids)]
            a, b, c = points[prev], points[current], points[following]
            if cross(a,b,c)*sign <= 1e-8:
                continue
            if any(k not in [prev,current,following] and all(v*sign >= -1e-8 for v in [cross(a,b,points[k]),cross(b,c,points[k]),cross(c,a,points[k])]) for k in ids):
                continue
            triangles.append([a,b,c]);ids.pop(j);found=True;break
        assert found, 'Invalid or self-intersecting mech outline'
    triangles.append([points[i] for i in ids])
    assert len(triangles) == len(points)-2
    assert abs(sum(abs(cross(*t)) for t in triangles)-abs(area)) < 1e-6
    return triangles
