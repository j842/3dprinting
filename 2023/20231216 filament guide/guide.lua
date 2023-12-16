-- Dual filament guide
-- based on https://www.thingiverse.com/thing:3377145

---------------------------------


showclippart=false
showarm=true

---------------------------------



package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

-- print settings
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',false)
set_setting_value('add_brim',false)

set_brush_color (0,.1,.5,.5)
set_setting_value('infill_percentage_0',100)

set_brush_color(1,0,1,0)
set_setting_value('infill_percentage_1',20)

set_brush_color(2,1,1,0)
set_setting_value('infill_percentage_2',40)


-------------------------------------------
function legdim()
  return v(12,45,12)
end

function getlegbox()
  local d=legdim()
  local legbox=translate(3-d.x/2,-d.y/2,0)*cube(d.x,d.y,d.z)
  return legbox
end

function getholebox()
  local d=legdim()
  local l=10
  local holebox=translate(3-d.x/2,-45+l/2,0)*cube(d.x,l,d.z)
  return holebox
end

-------------------------------------------


---
part2a=load_centered_on_plate('Filament_Guide_Holder.stl')
part2a=rotate(90,Z)*part2a
cs=bbox(part2a):extent()
-- 7,15

l1=80
l2=175

--part2=difference(part2a,defaultleg)
part2=intersection(translate(0,39,0)*cube(80,80,80),part2a)
part2=translate(3,0,0)*part2
antihole=difference(
  cylinder(3,legdim().z),
  jshapes.xycenter(intersection(part2a,getholebox()))
)

lx=12
ly=l2+8
lz=12
part2=union(part2,translate(0,-ly/2,0)*cube(lx,ly,lz))

round=difference(part2,translate(0,-ly+8,0)*cylinder(6,legdim().z))
round=intersection(round,translate(0,-ly,0)*cube(12,12,12))

part2=difference(part2,translate(0,0,0)*round)

part2=difference(part2,translate(0,-l1,0)*antihole)
part2=difference(part2,translate(0,-l2,0)*antihole)


part2=jshapes.xycenter(part2)

part2=rotate(45,Z)*part2

if (showarm) then
  emit(part2,2)
end


----------------------------------------------

-- Dual Clip

clip=load_centered_on_plate('HeavyShortDualClip.stl')

-- use the 4mm nice PFTE holes
nicehole=intersection(part2a,getholebox())
ops=rotate(270,X)*mirror(Z)
nicehole=jshapes.xycenter(ops*nicehole)
holes=translate(12.5,60.5-8,29.5-6)*nicehole
holes=union(holes,mirror(X)*holes)

-- thin the zip tie region
thinrect=translate(-20,-30,9)*cube(10,62,30)
thinrect=union(thinrect,mirror(X)*thinrect)
clip=difference(clip,thinrect)

thinrect=translate(-15,-10,11)*cube(32,110,5)
thinrect=union(thinrect,mirror(X)*thinrect)
clip=difference(clip,thinrect)

clip=difference(clip,holes)

x=translate(-60,0,0)

if (showclippart) then
  emit(x*holes,0)
  emit(x*clip,1)
end