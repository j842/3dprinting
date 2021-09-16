package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

function invert(obj)
local b=bbox(obj):extent()
local c=ccube(0.99*b)
c=translate(bbox(obj):center())*c
return difference(c,obj)
end

function getcat(zt)
local cat=load_centered_on_plate('bossmainer.stl')
cat=invert(cat)
cat=mirror(v(0,0,1))*cat
cat=scale(1,1,zt/bbox(cat):extent().z)*cat
--cat=scale(1,1,0.5)*cat
return cat
end

function mirrorx(obj)
return union(obj,mirror(v(1,0,0))*obj)
end


layerh=2/10
baselayers=5

basethickness=baselayers*layerh
topthickness=20*layerh

set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',layerh)
set_setting_value('z_layer_height_mm',layerh)
set_setting_value('gen_supports',false)
set_setting_value('infill_percentage_0',5)
set_setting_value('infill_percentage_1',5)
-- layer index starts at 0.
set_setting_value('FilamentSwapLayer',baselayers)


cat=getcat(topthickness)
toplayer=union({cat,letters})
toplayer=jshapes.xycenter(toplayer)
toplayer=translate(0,0,basethickness)*toplayer


width=bbox(toplayer):extent().x+12
height=bbox(toplayer):extent().y+10

botlayer=cube(width,height,basethickness)
screwholeradius=2

holes=mirrorx(translate(width/2,0,0)*cylinder(screwholeradius,basethickness))
holeback=mirrorx(translate(width/2,0,0)*cylinder(6,basethickness))
botlayer=union(botlayer,holeback)
botlayer=difference(botlayer,holes)

set_brush_color (1,1,1,1)
set_brush_color (2,0,0,0)
emit(toplayer,1)
emit(botlayer,2)



