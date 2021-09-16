-- holder for nametags.
package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")
jtags2=require("jtags2")

-- print settings
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.15)
set_setting_value('gen_supports',true)
set_setting_value('infill_percentage_0',5)

-- position the holder
hold=jtags2.holder()
hold=jshapes.xycenter(rotate(90,X)*hold)
emit(hold)
