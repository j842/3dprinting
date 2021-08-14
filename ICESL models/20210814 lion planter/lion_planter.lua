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
    lhead=translate(0,0,-3)*lhead
    lhead=scale(sc)*lhead
    return lhead
  end

  
function leafy(sc)
    local lpot=load_centered_on_plate('leaf.stl')
    lz=bbox(lpot):extent().z
    -- scale to 0.3mm thick
    lpot=scale(sc,sc,0.3/lz)*lpot
    return lpot
  end   

--- Scale factor - determines size of lion.
  k=1.0

--- 
  t=1+3*k
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

  shw=0.8*(2*r-2*t)
  sht=t+1
  shh=0.5*h/4
  spouthole=union(
    translate(0,-t/2,t)*cube(shw,sht,shh),
    translate(0,0,t+shh)*
    rotate(90,X)*cylinder(shw/2,sht))
  
  p=difference(union(p,spout),spouthole)


  -- lion
  p=union(p,
      translate(0,0,2*h/3)*rotate(270,X)*rotate(180,Z)*flion(k))


  -- leaves (protruding on front)
  leaf=translate(28*k,0,h/2)*rotate(270,X)*rotate(180,Z)*leafy(k)
  leaf=union(leaf,mirror(X)*leaf)
  p=union(p,leaf)

  -- leaves (embossed on back and sides)
  leaf2=translate(0,-kw,0)*leaf
  p=difference(p,leaf2)
  leaf3=translate(kw/2,-kw/2,0)*rotate(90,Z)*leaf
  leaf3=union(leaf3,mirror(X)*leaf3)
  p=difference(p,leaf3)
  emit(p)

--  emit(flion(1))
-- emit(leafy(1))