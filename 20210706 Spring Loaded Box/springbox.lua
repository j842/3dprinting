-- Spring Loaded Box

-- print settings
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',false)
set_setting_value('infill_percentage_0',5)

-- position the holder
sbox=load_centered_on_plate('PiP-Spring-loaded Box.stl')
emit(sbox)