 -- Welcome to IceSL!

h=5

function centerobj(objtocenter)
    local v=bbox(objtocenter):center()
    objtocenter=translate(-v.x,-v.y,-v.z)*objtocenter
    return objtocenter
end

f=font(Path..'/../ttf/StardosStencil-Bold.ttf')
letters=rotate(0,180,0)*scale(2,2,10*h)*f:str('Slade',1)
letters=centerobj(letters)
bb=bbox(letters):extent()
letters=translate(0,0,bb.z/2)*letters


spike = implicit_distance_field(v(-2,-2,0), v(2,2,8),
[[
float distance(vec3 p) {
	return 0.01 * ((pow(sqrt(p.x*p.x + p.y*p.y) - 3, 3) + p.z*p.z - 1) );
}
]])
spike=translate(-bb.x/2-4,-bb.y/2-4,h)*scale(2)*spike
spike=union(spike,mirror(v(1,0,0))*spike)
spike=union(spike,mirror(v(0,1,0))*spike)

xy=bbox(spike):extent()
--box=cube(xy.x,xy.y,h)
--letters=difference(box,letters)

--emit(letters)

enclosure=translate(0,0,0)*cube(xy.x,xy.y,xy.y)

ramp=translate(-xy.x/2,xy.y/2,xy.y+h)*rotate(0,90,0)*cylinder(xy.y,xy.x)
ramp=difference(enclosure,ramp)

tag=difference(
ramp,letters
)

emit(tag)
