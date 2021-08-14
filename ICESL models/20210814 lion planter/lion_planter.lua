-- Lion Planter

printplanter=true
printbase=false

---------------------------------------

-- print settings
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.3)
set_setting_value('gen_supports',false)
set_setting_value('add_brim',false)

set_brush_color (0,.1,.5,.5)
set_setting_value('infill_percentage_0',5)
set_setting_value('cover_thickness_mm_0',1.5)

set_brush_color(1,0,1,0)
set_setting_value('infill_percentage_1',100)
set_setting_value('cover_thickness_mm_0',1.2)

----------------------------------------------

function flion(sc)
    local lhead=load_centered_on_plate('lionhead.stl')
    lhead=scale(sc)*lhead
--    lhead=translate(-bbox(l):min_corner().x-bbox(l):extent().x/2,-bbox(l):max_corner().y,0)*l
    return lhead
  end

  
function leafy(sc)
    local lpot=load_centered_on_plate('leaf.stl')
    lz=bbox(lpot):extent().z
    lpot=scale(sc,sc,1/lz)*lpot
--    l=translate(-bbox(l):min_corner().x-bbox(l):extent().x/2,-bbox(l):max_corner().y,0)*l
    return lpot
  end   

  k=1.0
  t=3
  w=80
  h=k*80
  kw=k*w
  r=kw/5

 -- main cube
  p=difference(cube(kw,kw,h),translate(0,0,t)*cube(kw-2*t,kw-2*t,h-t))
  p=translate(0,-kw/2,0)*p

  -- spout
  spout=difference(
      union(
        translate(0,r/2,0)*cube(2*r,r,h/3),
        translate(0,r,0)*cylinder(r,h/3)
      ),
      union(
        translate(0,r/2-t/2,t)*cube(2*r-2*t,r,h/3-t),
        translate(0,r,t)*cylinder(r-t,h/3-t)
      )
    )

  p=union(p,spout)
  emit(p)

--  emit(flion(1))
-- emit(leafy(1))