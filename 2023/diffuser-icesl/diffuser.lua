 -- Welcome to IceSL!

set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',false)
set_setting_value('infill_percentage_0',15)


-- center in x and y, and place on z=0 surface.
function xycenter(objtocenter)
  local v=bbox(objtocenter):center()
  objtocenter=translate(-v.x,-v.y,-v.z)*objtocenter
  local h=bbox(objtocenter):min_corner().z
  return translate(0,0,-h)*objtocenter
end


gap=0.14*2
innerr=24/2+gap
shroudw=60
hd=1.3
t=0.5
happythick=2
totalh=55

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
cone(r0,r1-happythick,h1)
)
)
a=union(a,
translate(0,0,h1+h0)*
difference(
cylinder(r1,h2),
cylinder(r1-happythick,h2)
)
)

base=cylinder(shroudw/2,hd)
a=union(a,base)

b=cylinder(24/2+gap,totalh)
a=difference(a,b)

--c=difference(cylinder(80,60),cylinder(30,60))
-- c=translate(0,0,1.13)*c
--a=difference(a,c)


-- a=load('xxyyzz_diff_4x_su_lente_con_parz.antirifl.stl')

-- a=rotate(0,180,0)*a
-- a=xycenter(a)

-- a=scale(0.420 + 2*gap*(0.42/24))*a




--d=difference(cylinder(30,hd),cylinder(24.5,hd))




shroud=difference(cylinder(shroudw/2,totalh),cylinder(shroudw/2-t,totalh))
--a=union(a,shroud)




emit(a)

--emit(cylinder(24/2,30))
