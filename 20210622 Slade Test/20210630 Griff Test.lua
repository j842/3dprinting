-- Griff Namebadge
-- https://3dp.rocks/lithophane/

h=5

function centerobj(objtocenter)
    local v=bbox(objtocenter):center()
    objtocenter=translate(-v.x,-v.y,-v.z)*objtocenter
    return objtocenter
end

f=font(Path..'/../ttf/StardosStencil-Bold.ttf')
letters=rotate(0,180,0)*scale(2,2,10*h)*f:str('Griff',1)
letters=centerobj(letters)
bb=bbox(letters):extent()
letters=translate(0,0,bb.z/2)*letters

xy=v(bb.x+15,bb.y+15,0)

enclosure=translate(0,0,0)*cube(xy.x,xy.y,xy.y)

ramp=translate(-xy.x/2,xy.y/2,xy.y+h)*rotate(0,90,0)*cylinder(xy.y,xy.x)
ramp=difference(enclosure,ramp)

tag=difference(
ramp,letters
)

lithopane=load_centered(Path..'griffbw.jpegW99H100T3V4B2A0C0NS.stl')
l=scale(xy.y/100)*lithopane
le=bbox(l):extent()
l=translate(-xy.x/2-le.x/2,0,le.z/2)*l
l=union(mirror(v(1,0,0))*l,l)

tag=union(tag,l)

tag=rotate(90,0,0)*tag

emit(tag)
