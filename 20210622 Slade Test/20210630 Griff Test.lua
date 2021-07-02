-- Griff Namebadge
-- https://3dp.rocks/lithophane/

package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

h=20
w=120
t=2
g=3
e=2

lithopane=load_centered(Path..'griffbw.jpegW99H100T3V4B2A0C0NS.stl')
l=scale(h/bbox(lithopane):extent().x)*lithopane
le=bbox(l):extent()
l=translate(-w/2+le.x/2,0,le.z/2)*l
l=union(mirror(v(1,0,0))*l,l)


f=font(Path..'/../ttf/StardosStencil-Bold.ttf')
letters=rotate(0,180,0)*f:str('Griff',1)

-- scale text to h-2*g height.
lscale=(h-2*g)/bbox(letters):extent().y
letters=scale(lscale)*letters
letters=jshapes.xycenter(letters)

tag=translate(0,0,0)*cube(w-2*le.x,h,t)

tag=difference(
tag,letters
)

border=difference(cube(w,h,t),cube(w-e,h-e,t))

tag=union({tag,l,border})

tag=rotate(90,0,0)*tag

set_brush_color (1,1,1,1)
emit(tag,1)
