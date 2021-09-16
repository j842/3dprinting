-- Holder for LED light for Ender 3 Pro
-- LED is Arlec UC473, wide angle corned led bar light
-- https://www.bunnings.co.nz/arlec-7w-aluminium-wide-angle-corner-led-bar-light_p0099381




---------------------------------------

-- print settings
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',false)
set_setting_value('add_brim',true)

-- planter brush
set_brush_color (0,.1,.3,.5)
set_setting_value('infill_percentage_0',20)

----------------------------------------------

function xycenter(objtocenter)
  local v=bbox(objtocenter):center()
  objtocenter=translate(-v.x,-v.y,-v.z)*objtocenter
  local h=bbox(objtocenter):min_corner().z
  return translate(0,0,-h)*objtocenter
end
----------------------------------------------


l=110
h=16

----------------------------------------------
function rail(z)
  local iholder=xycenter(rotate(90,X)*rotate(90,Y)*load_centered_on_plate('rail.stl'))

  iholder=scale(1,1,z/bbox(iholder):extent().z)*iholder
  iholder=translate(
    bbox(iholder):extent().x/2-1,-32,0)*iholder
  iholder=rotate(0,0,180)*iholder
  return iholder
end

----------------------------------------------
-- add bar
function bar(z)
  local iholder=
    translate(l/2,32,0)*
  cube(l,12,h/2)
  for cx=10,l-30,10 do
    iholder=difference(iholder,
      translate(cx,32,0)*cylinder(2,z))
  end
  return iholder
end

----------------------------------------------
function lightoutline(z)
 local rad=22
 return translate(0,-3,0)*cylinder(rad,z)
end

function grabber(z)
  local lr=36/2
  local dy=-3
  local lighthole=translate(0,dy,0)*intersection(cylinder(lr,z),translate(0,-lr/2,0)*cube(100,lr,z))

  lighthole=union({lighthole,
  translate(0,4+dy,0)*cube(14,18,z),
  translate(-6,dy+1,0)*rotate(0,0,45)*cube(16,18,z),
  translate(0,dy-1,0)*cube(36,5,z),
  translate(0,-21,0)*cube(lr*2,10,z)
  })
  lighthole=union(lighthole,mirror(v(1,0,0))*lighthole)

  local c= lightoutline(z)
  lighthole=difference(c,lighthole)
  return lighthole
end
----------------------------------------------


voff=v(l,20,0)
uniholder=union(
    translate(voff)*grabber(h/2),
    difference(
      union(rail(h),bar(h/2)),
      translate(voff)*lightoutline(h/2)
    )
  )

holders=union(uniholder,translate(51,40,0)*mirror(X)*uniholder)
emit(holders)



