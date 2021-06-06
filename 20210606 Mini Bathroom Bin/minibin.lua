-- mini bathroom bin

d=100
h=100
t=2
lidh=10
gap=5

hingew=25
hingeh=10
hinged=30

body=cylinder(d/2,h)

cr=5
cgap=0.5
cw=(hingew-2*cgap)/3

hingebot=translate(0,-d/2-gap,h-lidh-hingeh-cr-cgap)*cube(hingew,hinged,hingeh)
hinge1=translate(hingew/2-cw/2,-d/2-hinged/2+cr-gap,h-lidh-cr-cgap)*rotate(0,90,0)*ccylinder(cr,cw)
hinge2=translate(-hingew/2+cw/2,-d/2-hinged/2+cr-gap,h-lidh-cr-cgap)*rotate(0,90,0)*ccylinder(cr,cw)
hinge3=translate(0,-d/2-hinged/2+cr-gap,h-lidh-cr-cgap)*rotate(0,90,0)*ccylinder(cr,cw)

bhinge3=translate(0,-d/2-hinged/2+cr-gap,h-lidh-cr-cgap)*rotate(0,90,0)*ccylinder(cr+1,cw+1)


hingebot=union(hingebot,hinge1)
hingebot=union(hingebot,hinge2)

body=union(body,hingebot)
body=difference(
    body,
    translate(0,0,t)*cylinder(d/2-t,h-t)
)
body=difference(body,bhinge3)



lid=difference(
    cylinder(d/2+t+gap,lidh),
    cylinder(d/2+gap,lidh-t)
)
lid=translate(0,0,h-lidh)*lid

lid=union(lid,hinge3)
--body=difference(body,lid)

space=5
--lid=translate(d+t+gap+space,0,lidh)*mirror(v(0,0,1))*lid

emit(body)
emit(lid)