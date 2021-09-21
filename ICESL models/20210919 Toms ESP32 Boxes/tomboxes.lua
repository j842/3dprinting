
debug=false


----

lolin=require("lolin")

set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.15)
set_setting_value('gen_supports',true)
set_setting_value('support_overhang_overlap_fraction',0.9)
set_setting_value('infill_percentage_0',10)
set_setting_value('infill_percentage_1',100) -- mount
set_setting_value('infill_percentage_2',10)


set_brush_color(1,0,1,0)
set_brush_color (2,1,0,0)

----------------------------------------


-- MAIN
function main()
  local h=5
  local mnt=lolin.lolinv3mount(h)
  local boxt=2
  local bx=45
  local by=75
  local bz=boxt+1
  local fuzz=0.001

  local box=cube(bx,by,bz)
  box=difference(box,translate(0,0,boxt)*cube(bx-2*boxt,by-2*boxt,bz-boxt))
  local mnt=union(translate(0,0,boxt-fuzz)*mnt,
    box)
  emit(mnt,1)

  if (debug) then
    local y=translate(0,0,0.8)*rotate(180,X)*load('NodeMcu_V3.stl')
    y=translate(0,0,h)*y
    emit(y,2)
  end

  --local x=lolin.lolinv3template()
  --x=translate(0,0,h)*x
  --set_brush_color (3,1,0,1)
  --emit(x,3)
end


----------------------------------------
main()


