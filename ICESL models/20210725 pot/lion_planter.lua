-- Lion Planter

-- print settings
set_setting_value('use_different_thickness_first_layer',false)
--set_setting_value('z_layer_height_first_layer_mm',0.2)
set_setting_value('z_layer_height_mm',0.3)
set_setting_value('gen_supports',false)
set_setting_value('add_brim',false)

set_brush_color (0,.1,.5,.5)
set_setting_value('infill_percentage_0',5)

set_brush_color(1,0,1,0)
set_setting_value('infill_percentage_1',100)
set_setting_value('enable_ironing_1',false)

-- position the holder

halfthick=1.5
sbox=load_centered_on_plate('pot.stl')
sbox=scale(15/10)*sbox


-- base
ss=bbox(sbox):extent()
basecube=cube(ss.x+2*halfthick,ss.y+2*halfthick,halfthick*2)
base=difference(
  basecube,
  translate(0,0,halfthick)*sbox
)

trimmedbase=intersection(base,union(
cube(ss.x+2*halfthick,ss.y+2*halfthick,halfthick),
scale(1.2,1.1,1)*difference(basecube,base)))

cutout=difference(base,trimmedbase)
base=trimmedbase
base=difference(base,translate(0,0,-halfthick)*cutout)

base=scale(1.04,1.02,2)*base



emit(base,1)
--emit(translate(0,0,halfthick)*sbox,0)
