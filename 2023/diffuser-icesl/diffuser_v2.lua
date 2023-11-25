-- diffuser for microscope objective

set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',false)
set_setting_value('infill_percentage_0',15)


-- width of microsccope objective lens
objectivew=24


gap=0.2
innerr=objectivew/2+gap
shroudw=58
happythick=3
viewthick=1
totalh=65

r0=innerr+happythick
r1=r0+4
r2=r1
h0=14
h1=10
h2=10

a=cylinder(r0,h0)
a=union(a,
translate(0,0,h0)*
difference(
cone(r0,r1,h1),
cone(r0-viewthick,r1-viewthick,h1)
)
)

a=union(a,
 translate(0,0,h1+h0)*
 difference(
 cylinder(r1,h2),
 cylinder(r1-viewthick,h2)
 )
 )

base=union(
cylinder(shroudw/2,happythick),
cylinder(r0+happythick,2*happythick)
)
a=union(a,base)

b=cylinder(innerr,totalh)
a=difference(a,b)

--a=translate(0,0,happythick)*a
--emit(a)

---------------------------------------------

topr=60
bracketw=50

top=difference(
cylinder(topr,happythick),
union(
{
cylinder(innerr,totalh),
translate(topr/2,0,0)*ccube(topr,innerr*2,totalh),
translate(topr/2+shroudw/2,0,0)*ccube(topr,bracketw,totalh)
}))

top=union(top,
difference(cylinder(topr,totalh),cylinder(topr-viewthick,totalh))
)

magich=30
top=difference({top,
translate(topr,0,magich)*cone(bracketw/2,0,magich+2),
translate(topr,0,0)*cube(topr,bracketw,magich+0.1)}
)

emit(top)



--emit(cylinder(24/2,30))
