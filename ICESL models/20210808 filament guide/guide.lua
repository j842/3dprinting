-- Dual filament guide
-- based on https://www.thingiverse.com/thing:3377145

-- print settings
set_setting_value('use_different_thickness_first_layer',false)
--set_setting_value('z_layer_height_first_layer_mm',0.2)
set_setting_value('z_layer_height_mm',0.3)
set_setting_value('gen_supports',false)
set_setting_value('add_brim',false)

set_brush_color (0,.1,.5,.5)
set_setting_value('infill_percentage_0',100)

set_brush_color(1,0,1,0)
set_setting_value('infill_percentage_1',20)
--set_setting_value('enable_ironing_1',false)

----------------------------------------------

-- Dual Clip

clip=load_centered_on_plate('HeavyShortDualClip.stl')
cs=bbox(clip):extent()

inner=union({
  cylinder(2.05,7),
  translate(0,0,8)*cylinder(2.05,7),
  cylinder(1.25,15)
})
holes=difference(cylinder(6,15),inner)
holes=rotate(90,X)*holes
holes=translate(12.5,60.5,29.5)*holes
holes=union(holes,mirror(X)*holes)

clip=difference(clip,holes)

x=translate(-40,0,0)

emit(x*holes,0)
emit(x*clip,1)


---
