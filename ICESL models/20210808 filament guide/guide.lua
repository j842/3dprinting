-- Dual filament guide
-- based on https://www.thingiverse.com/thing:3377145


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

function getleg(l,p)
  local x=legdim().x
  local y=legdim().y
  local y1=10
  local y3=15
  local y2=y-y1-y3
  local z=12
  local legbox1=translate(3-x/2,-y1/2,0)*cube(x,y1,z)
  local legbox2=translate(3-x/2,-y2/2-y1,0)*cube(x,y2,z)
  local legbox3=translate(3-x/2,-y3/2-y1-y2,0)*cube(x,y3,z)

  local leg1=intersection(p,legbox1)
  local leg2=intersection(p,legbox2)
  local leg3=intersection(p,legbox3)

  local s=(l-y + y2)/y2
  local ym1 = bbox(leg2):max_corner().y
  leg2=scale(1,1.01*s,1)*leg2
  local ym2 = bbox(leg2):max_corner().y
  leg2=translate(0,ym1-ym2,0)*leg2
  leg3=translate(0,y-l,0)*leg3

  local fullleg=union({leg1,leg2,leg3})
  
-- make thicker for strength
  local skip=l-7.4
  fullleg=union(fullleg,
    translate(-3,-skip/2,0)*
      difference(cube(8,skip,8),cube(3.5,skip,8))
  )

  return fullleg
end
-------------------------------------------


---
part2a=load_centered_on_plate('Filament_Guide_Holder.stl')
part2a=rotate(90,Z)*part2a
cs=bbox(part2a):extent()
-- 7,15

defaultleg=getlegbox()
leg1=getleg(70,part2a)
leg2=getleg(150,part2a)

part2=difference(part2a,defaultleg)
part2=union(part2,translate(4,0,0)*leg1)
part2=union(part2,translate(-3,0,0)*leg2)
part2=jshapes.xycenter(part2)


emit(part2,2)



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

clip=difference(clip,holes)

x=translate(-60,0,0)

--emit(x*holes,0)
--emit(x*clip,1)

