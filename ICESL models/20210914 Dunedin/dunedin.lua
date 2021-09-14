-- print settings
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.1)
set_setting_value('gen_supports',false)
set_setting_value('add_brim',false)

set_setting_value('FilamentSwapLayer',8)

-- land brush
set_brush_color (0,.1,1,.5)
set_setting_value('infill_percentage_0',10)
set_setting_value('cover_thickness_mm_0',1.2)

-- sea brush
set_brush_color(1,.1,.2,.7)
set_setting_value('infill_percentage_1',5)
set_setting_value('cover_thickness_mm_1',1.5)


x=load_centered_on_plate('DunedinNZColour_fixed.stl')
base=3
bb=1.01*bbox(x):extent()
y=difference(x,translate(0,0,-20+base)*cube(bb.x,bb.y,20))
y=translate(0,0,-base)*y
y=scale(1,1,2)*y

actualbase=1
y=translate(0,0,actualbase)*y
emit(y,0)

emit(cube(bb.x,bb.y,actualbase),1)