package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")
jtags3=require("jtags3")
v3=require("v3")

set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.15)
set_setting_value('gen_supports',true)
set_setting_value('support_overhang_overlap_fraction',0.9)
set_setting_value('infill_percentage_0',5)
set_setting_value('infill_percentage_1',100) -- mount
set_setting_value('infill_percentage_2',5)



-- MAIN
function main()
  local h=5
  local mnt=v3.mount(h)
  set_brush_color(1,0,1,0)
  emit(mnt,1)

  local y=translate(0,0,0.8)*rotate(180,X)*load('NodeMcu_V3.stl')
  y=translate(0,0,h)*y
  set_brush_color (2,1,0,0)
  --emit(y,2)

  local x=v3.template()
  x=translate(0,0,h)*x
  set_brush_color (3,1,0,1)
  --emit(x,3)

  set_brush_color (0,0,0,0.1)
  local hold=jtags3.holder()
  hold=jshapes.xycenter(rotate(90,Z)*rotate(90,X)*hold)
  hold=translate(0.5,-27,0)*hold
  emit(hold,0)
end


----------------------------------------
main()
