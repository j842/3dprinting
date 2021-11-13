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



-- center in x and y, and place on z=0 surface.
function xycenter(objtocenter)
  local v=bbox(objtocenter):center()
  objtocenter=translate(-v.x,-v.y,-v.z)*objtocenter
  local h=bbox(objtocenter):min_corner().z
  return translate(0,0,-h)*objtocenter
end

actualbase=1
xx=75

function getland(filename)
local x=load_centered_on_plate(filename)
local base=0
local bb=bbox(x):extent()

local yy=bb.y/bb.x*xx

local y=difference(x,translate(0,0,-20+base)*cube(bb.x,bb.y,20))
y=translate(0,0,-base)*y
local sx=xx/bb.x
local sy=yy/bb.y
y=scale(sx,sy,1)*y

local y=translate(0,0,actualbase)*y
return y
end

y=getland('rawmodel-69356.stl')

y2=getland('rawmodel-69362.stl')
y2=translate(-34.98*xx/50,-46.3*xx/50,0)*y2

y3=translate(0,0,actualbase-0.3)*xycenter(union(y,y2))

bb=bbox(y3):extent()
sea=cube(bb.x,bb.y,actualbase)

y3=difference(y3,sea)

emit(y3,0)
emit(sea,1)
