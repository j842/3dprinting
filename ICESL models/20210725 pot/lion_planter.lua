-- Lion Planter

-- print settings
set_setting_value('use_different_thickness_first_layer',false)
--set_setting_value('z_layer_height_first_layer_mm',0.2)
set_setting_value('z_layer_height_mm',3/10)
set_setting_value('gen_supports',false)
set_setting_value('add_brim',false)

set_brush_color (0,.1,.5,.5)
set_setting_value('infill_percentage_0',5)

set_brush_color(1,0,1,0)
set_setting_value('infill_percentage_1',100)
set_setting_value('enable_ironing_1',false)

-- position the holder

sboxsize=15/10

halfthick=15/10
sbox=load_centered_on_plate('pot.stl')
--sbox=scale(sboxsize)*sbox
ss=bbox(sbox):extent()


function sbase(off)
  local w=2*off+ss.x
  local ws=2*off+ss.y-ss.x
  local z=2*halfthick
  local base=cube(w,w,z)
  local r=4*ws/6
  base=union(
    translate(0,(ss.y-ss.x)/2,0)*base,
    translate(0,-ss.x/2,0)*
      intersection(
        cube(ws,ws,z),
        translate(0,-ws/2+r,0)*cylinder(r,z)
      )
  )
  return base
end

base=sbase(5)



--basecube=cube(2*ss.x,2*ss.y,halfthick*2)
--sbase=intersection(basecube,scale(1,1,10)*sbox)
--w=5
-- wiggle around the planter to create a boundary.
--basecube=intersection(basecube,
-- union({
--   translate(w,w,0)*sbase,
--   translate(-w,-w,0)*sbase,
--   translate(-w,w,0)*sbase,
--   translate(w,-w,0)*sbase,
--   translate(0,-1.05*w,0)*sbase
-- })
-- )

--base=difference(intersection(basecube,scale(1.2,1.1,1)*sbase),
--  translate(0,0,halfthick)*scale(1.04,1.02,1)*sbase)

--emit(sbase)

emit(base,1)
emit(translate(0,0,halfthick)*sbox,0)
