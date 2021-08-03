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

----------------------------------------------

-- Load the planeter model

sbox=load_centered_on_plate('pot.stl')
--sboxsize=15/10
--sbox=scale(sboxsize)*sbox
ss=bbox(sbox):extent()


-- Base for planter

function sbase(off,z)
  local w=2*off+ss.x
  local ws=2*off+ss.y-ss.x
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

halfthick=15/10
base=difference(
  sbase(4,2*halfthick),
  translate(0,0,halfthick)*sbase(1,halfthick)
)

emit(base,1)


-- Planter itself
offsetplanter=translate(0,0,halfthick)*sbox
--emit(offsetplanter,0)
--emit(sbox)
