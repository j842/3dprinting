package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

function invert(obj)
local b=bbox(obj):extent()
local c=ccube(0.99*b.x,0.99*b.y,0.1*b.z)
c=translate(bbox(obj):center())*c
return difference(c,obj)
end

function getcat(zt)
local cat=load_centered_on_plate('jackdragon.stl')
cat=invert(cat)
cat=mirror(v(0,0,1))*cat
cat=scale(1.3,1.3,zt/bbox(cat):extent().z)*cat
--cat=scale(1,1,0.5)*cat
return jshapes.xycenter(cat)
end

function mirrorx(obj)
return union(obj,mirror(v(1,0,0))*obj)
end

function getletters(zt)
local str='Jack\'s Room'
local texth=10
local f=font(Path..'../ttf/Lato-Black.ttf')
local letters=jshapes.xycenter(f:str(str,1))
local e = bbox(letters):extent()
local factor = texth/e.y
letters=scale(factor,factor,zt/e.z)*letters
letters=translate(0,-23,0)*letters

local l2=jshapes.xycenter(f:str('Dragons will get you!',1))
e = bbox(l2):extent()
factor = texth/1.5/e.y
l2=scale(factor,factor,zt/e.z)*l2
l2=translate(0,-33,0)*l2
return union(letters,l2)
end



layerh=2/10
baselayers=5

basethickness=baselayers*layerh
topthickness=3*layerh

set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',layerh)
set_setting_value('z_layer_height_mm',layerh)
set_setting_value('gen_supports',false)
set_setting_value('infill_percentage_0',5)
set_setting_value('infill_percentage_1',5)
-- layer index starts at 0.
set_setting_value('FilamentSwapLayer',baselayers)

cat=getcat(topthickness)
letters=getletters(topthickness)
toplayer=union({cat,letters})
toplayer=jshapes.xycenter(toplayer)
toplayer=translate(0,0,basethickness)*toplayer

width=bbox(toplayer):extent().x+12
height=bbox(toplayer):extent().y+10

botlayer=cube(width,height,basethickness)
screwholeradius=1.5

holes=mirrorx(translate(width/2,0,0)*cylinder(screwholeradius,basethickness))
holeback=mirrorx(translate(width/2,0,0)*cylinder(6,basethickness))
botlayer=union(botlayer,holeback)
botlayer=difference(botlayer,holes)

set_brush_color (1,1,1,1)
set_brush_color (2,0,0,0)
emit(toplayer,1)
emit(botlayer,2)



