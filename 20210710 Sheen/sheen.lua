package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

--[[ 

Either 
(1) Manually edit the GCode to add in an M600 command before layer 4.

OR

(2) Create a printer profile with this code added to the top of the layer_start function in printer.lua:

  if (layer_id>0 and layer_id==FilamentSwapLayer) then
    output('; JE- swap filament!')
    output('M600')
    output('; ------------------')
  end

And this code added to features.lua:

  add_setting('FilamentSwapLayer','Change filaments at start of given layer; disable if set to 0', 0, 1000, 'Swap at start of this layer, 0 is disabled',0)

 ]]


-- print settings
layerh=0.30
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',layerh)
set_setting_value('z_layer_height_mm',layerh)
set_setting_value('gen_supports',false)
set_setting_value('infill_percentage_0',5)
set_setting_value('infill_percentage_1',5)
set_setting_value('FilamentSwapLayer',4)

-- subtract a little fuzz so the slicer doesn't create an extra layer!
thickness=3*layerh-0.001
basethickness=4*layerh-0.001

-- other settings
str='30 Sheen St'
texth=20
gap=8
height=texth*2 + 3*gap
screwholeradius=1.6

-- so want to change filament at end of layer 3,
-- before we start layer 4. (4,5,6 are text).

local f=font(Path..'../ttf/Lato-Black.ttf')
local letters=jshapes.xycenter(f:str(str,1))
local e = bbox(letters):extent()

local factor = texth/e.y
letters=scale(factor,factor,thickness/e.z)*letters
local textw = bbox(letters):extent().x
local width=textw + 2*2*gap

letters=translate(0,texth/2+gap/2,basethickness)*letters

x0=-50
x1=-30
x2=40
arrow=linear_extrude(v(0,0,thickness),
   {v(x0,0),v(x1,texth/2),v(x1,texth/4),v(x2,texth/4),v(x2,-texth/4),v(x1,-texth/4),v(x1,-texth/2)})

arrow=mirror(v(1,0,0))*translate(0,-texth/2-gap/2,basethickness)*arrow

writing=union(letters,arrow)


function mirrorx(obj)
return union(obj,mirror(v(1,0,0))*obj)
end

backing=cube(width,height,basethickness)
holes=mirrorx(translate(width/2,0,0)*cylinder(screwholeradius,basethickness))
holeback=mirrorx(translate(width/2,0,0)*cylinder(6,basethickness))
backing=union(backing,holeback)
backing=difference(backing,holes)

set_brush_color (1,1,1,1)
set_brush_color (2,0,0,0)
emit(writing,1)
emit(backing,2)
