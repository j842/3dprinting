-- Simple shower leak stop strip.
-- 620mm long, and with holes for three screws.
-- three parts to be glued together.

cr=6
ov=20

-- lose two lots of ov in the overlaps, so
-- have to extend that much.
l=(620+2*ov)/3

x=rotate(90,Y)*cylinder(cr,l)
y=intersection(x,cube(2*l,2*l,l))
y=difference(y,translate(0,cr/2,0)*cube(ov,cr,10))

z=difference(y,translate(l,cr/2,0)*cube(ov,cr,10))

deepz=2
screwhole=union(
{
  translate(0,0,cr-4.6-deepz)*cone(4.8/2,9.1/2,v(0,0,0),v(0,0,4.6)),
  translate(0,0,cr-deepz)*cylinder(9.1/2,deepz+0.1),
  cylinder(4.8/2,cr)
}
)

--z=difference(z,translate(l/2,0,cr-4.6)*
--cone(4.8/2,9.1/2,v(0,0,0),v(0,0,4.6)))
--z=difference(z,translate(l/2,0,0)*
--cylinder(4.8/2,cr))

z=difference(z,translate(l/2,0,0)*screwhole)
y=difference(y,translate(l-8,0,0)*screwhole)

rods=translate(3,0,0)*union({
  y,
  translate(0,cr*2+4,0)*z,
  translate(0,cr*4+8,0)*y
})

emit(rods)