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

pinr=2
pin=translate(0,hingety,hingetz)*rotate(0,90,0)*ccylinder(pinr,hingew)

body=difference(body,pin)


-- LID
lid=cylinder(d/2+t+gap,lidh)
lid=difference(
    lid,
    cylinder(d/2+gap,lidh-t)
)
lid=translate(0,0,h-lidh)*lid

--hinge3=union(hinge3, 
--   translate(0,-d/2-gap,h-lidh)*cube(cw,hinged,hingeh)
--)
hinge3=union(hinge3, 
translate(0,-d/2-gap-(hinged-cr*2)/2,h-lidh-cr)*cube(cw,cr*2,cr+lidh)
)


lid=union(lid,hinge3)

lid=difference(lid,pin)


body=difference(body,lid)

space=5
--lid=translate(d+t+gap+space,0,h)*mirror(v(0,0,1))*lid

emit(body)
emit(lid)