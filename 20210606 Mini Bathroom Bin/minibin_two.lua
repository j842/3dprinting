-- mini bathroom bin

d=100
h=100
t=2
lidh=5
gap=2

hingew=25
hingeh=8
hinged=20

body=cylinder(d/2,h)

cr=5
cgap=0.5
cw=(hingew-2*cgap)/3


hingetz=h-lidh-cr-cgap
hingety=-d/2-hinged/2+cr-gap

hingebot=translate(0,-d/2-gap,hingetz-hingeh)*cube(hingew,hinged,hingeh)

function hingecircle(tx,enlarge)
    return translate(tx,hingety,hingetz)*rotate(0,90,0)*ccylinder(cr+enlarge,cw+enlarge)
end

hinge1=hingecircle(hingew/2-cw/2,0)
hinge2=hingecircle(-hingew/2+cw/2,0)
hinge3=hingecircle(0,0)
bhinge3=hingecircle(0,1)

hingebot=union(hingebot,hinge1)
hingebot=union(hingebot,hinge2)

body=union(body,hingebot)
body=difference(
    body,
    translate(0,0,t)*cylinder(d/2-t,h-t)
)
body=difference(body,bhinge3)

pinr=2.1 -- m4 screw radius is 2mm.
pin=translate(0,hingety,hingetz)*rotate(0,90,0)*ccylinder(pinr,hingew)

body=difference(body,pin)


-- LID
lidr=d/2+t+gap
lid=cylinder(lidr,lidh)
lid=translate(0,0,h-lidh)*lid
lidinner=translate(0,0,h-lidh)*cylinder(d/2+gap,lidh-t)


hinge3=union(hinge3, 
translate(0,-d/2-gap-(hinged-cr*2)/2,h-lidh-cr)*cube(cw,cr*2,cr+lidh)
)
lid=union(lid,hinge3)

lid=difference(lid,pin)

function centerobj(objtocenter)
    local v=bbox(objtocenter):center()
    objtocenter=translate(-v.x,-v.y,-v.z)*objtocenter
    return objtocenter
end

f=font(Path..'StardosStencil-Bold.ttf')
letters=rotate(0,0,180)*scale(4,4,lidh)*centerobj(f:str('Paru',1))
letters=translate(0,0,d)*letters

lid=difference(lid,letters)

lidtab=translate(0,lidr,d-lidh)*cube(30,10,lidh)
lidtab=difference(lidtab,cylinder(d/2+gap,lidh-t))

lid=union(lid,lidtab)
lid=difference(lid,lidinner)

body=difference(body,lid)

space=5
shift=d+t+gap+space
lid=translate(shift,0,h)*rotate(180,0,0)*lid

emit(body)
emit(lid)
