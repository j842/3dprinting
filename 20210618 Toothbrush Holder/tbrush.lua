 -- Welcome to IceSL!

iholder=load_centered_on_plate('UTBDS_E_4_Quad.stl')
bx=bbox(iholder):extent()
x=bx.x
y=bx.y
z=bx.z

b=cylinder(2,10)
c=b
for a=0,360,45 do
  c=union(c,rotate(a,v(0,0,1))*translate(8,0,0)*b)
end


c=translate(0,-y/2+5,z/2)*rotate(90,0,0)*c

ho=x/11
c1=union({
translate(ho,0,0)*c,
translate(-ho,0,0)*c,
translate(3*ho,0,0)*c,
translate(-3*ho,0,0)*c})

iholder=difference(iholder,c1)


bsy = 6
bsx = x-40
bsz = z
gap = 6

base=difference(cube(bsx,bsy,bsz),
translate(0,1,5)*
cube(bsx-10,bsy-2,bsz-10))
base=translate(0,-y/2-bsy/2-gap+1,0)*base


rollers=translate(-bsx/2,-y/2-gap/2+0.5,gap/2)*rotate(0,90,0)*cylinder(gap/2,bsx)
rollers=union(rollers,translate(0,0,z-gap)*rollers)


holder=union({base,rollers,iholder})


function centerobj(objtocenter)
    local v=bbox(objtocenter):center()
    objtocenter=translate(-v.x,-v.y,-v.z)*objtocenter
    return objtocenter
end

f=font(Path..'StardosStencil-Bold.ttf')
function maketext(label,xc)
letters=scale(-1.5,1.5,10)*centerobj(f:str(label,1))
letters=translate(xc,-2,0)*letters
return letters
end

letters=union({
maketext('John',3*ho),
maketext('Jack',ho),
maketext('Tom',-ho),
maketext('Katie',-3*ho)})

labelbox=cube(0.7*x,18,4)


letters=translate(0,y/2-15/2-2,0)*letters
labelbox=translate(0,y/2-15/2-2,0)*labelbox

holder=union(holder,labelbox)
holder=difference(holder,letters)

emit(holder)


cup=load_centered_on_plate('UTBDS_Cup.stl')
cup=translate(0,-3,0)*cup
emit(cup)



