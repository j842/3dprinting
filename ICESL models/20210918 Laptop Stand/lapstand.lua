-- Laptop stand
-- broken into two prints (print=1 and print=2)
print=1



-- print settings
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.2)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',true)
set_setting_value('add_brim',false)

--set_setting_value('FilamentSwapLayer',0)

-- main brush
set_brush_color (0,.5,.5,.5)
set_setting_value('infill_percentage_0',10)
set_setting_value('cover_thickness_mm_0',1.2)



function xycenter(objtocenter)
  local v=bbox(objtocenter):center()
  objtocenter=translate(-v.x,-v.y,-v.z)*objtocenter
  local h=bbox(objtocenter):min_corner().z
  return translate(0,0,-h)*objtocenter
end


if (print==1) then
  ls1=load_centered_on_plate('stl/Laptop_Stand_15_inch_Base.stl')
  emit(ls1)
  emit(translate(0,50,0)*ls1)

  ls3=load_centered_on_plate('stl/Laptop_Stand_15_inch_Support.stl')
  emit(translate(0,95,0)*ls3)
  emit(translate(0,-45,0)*ls3)


end

if (print==2) then
  ls2=load_centered_on_plate('stl/Laptop_Stand_15_inch_Laptop_holder.stl')
  emit(translate(-5,0,0)*ls2)
  emit(translate(5,22,0)*rotate(180,Z)*ls2)


  pc1=load_centered_on_plate('stl/pin_clip_mod_15.stl')
  pc2=load_centered_on_plate(
'stl/cap_mir_mod_15.stl')
  pc3=xycenter(rotate(180,Y)*load_centered_on_plate('stl/cap_mod_15.stl'))
  pc4=load_centered_on_plate('stl/hinge_pin_mod_15.stl')

  pieces=union({
    translate(40,35,0)*pc1,
    translate(70,35,0)*pc1,
    translate(40,70,0)*pc2,
    translate(40,100,0)*pc2,
    translate(40,0,0)*pc3,
    translate(40,-30,0)*pc3,
    translate(70,-10,0)*pc4,
    translate(70,90,0)*pc4
  })

  emit(translate(20,40,0)*rotate(90,Z)*pieces)
  
end
