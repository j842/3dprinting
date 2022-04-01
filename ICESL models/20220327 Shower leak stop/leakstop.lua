-- Simple shower leak stop strip.
-- 620mm long, and with holes for three screws.
-- three parts to be glued together.


set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',false)
set_setting_value('infill_percentage_0',15)

cr=6.7
ov=10

-- lose two lots of ov in the overlaps, so
-- have to extend that much.
l=(620+2*ov)/3

x=rotate(90,Y)*cylinder(cr,l)
y=intersection(x,cube(2*l,2*l,l))
y=difference(y,translate(ov/2,cr/2,0)*cube(ov,cr,10))

z=difference(y,translate(l-ov/2,-cr/2,0)*cube(ov,cr,10))

deepz=3
taperh=4.0
r1=4.8/2

holescale=9.1/8.2 -- at d=9.1, holes come out as 8.2 (actual, measured i3 Mk3s+ PETG)
r2=(9.1*holescale)/2 

screwhole=union(
{
  translate(0,0,cr-deepz)*cylinder(r2,deepz+0.001),
  translate(0,0,cr-taperh-deepz)*cone(r1,r2,v(0,0,0),v(0,0,taperh)),
  cylinder(r1,cr)
}
)

z=difference(z,translate(l/2,0,0)*screwhole)
y=difference(y,translate(l-2*cr,0,0)*screwhole)

spacing=cr*2+8

rods=translate(3,0,0)*union({
  y,
  translate(0,spacing,0)*z,
  translate(0,2*spacing,0)*y
})

emit(rods)