w=173
h=126
z=5

l=cube(w,h,z)

r=30
c=difference(
translate(w/2-r/2,h/2-r/2,0)*cube(r,r,z),
translate(w/2-r,h/2-r,0)*cylinder(r,z)
)
c=union(mirror(v(1,0,0))*c,c)
c=union(mirror(v(0,1,0))*c,c)

l=difference(l,c)

t=3
l=difference(
scale((w+2*t)/w,(h+2*t)/h,(z+t)/z)*l,
translate(0,0,t)*l)


function centerobj(objtocenter)
    local v=bbox(objtocenter):center()
    objtocenter=translate(-v.x,-v.y,-2*v.z)*objtocenter
    return objtocenter
end

f=font(Path..'StardosStencil-Bold.ttf')
letters=rotate(-90,0,0)*scale(2,2,t)*f:str('Wairakau',1)
bl=bbox(letters):extent()
letters=translate(-bl.x/2,h/2,bl.z+z+5)*letters

letters=difference(
translate(0,h/2+t/2,0)*cube(0.6*w,t,z+t+10+8),
letters)

letters=difference(
letters,
translate(4.5,h/2+t/2,z+t+2)*cube(6,t,1.6)
)


emit(letters)


emit(l)
