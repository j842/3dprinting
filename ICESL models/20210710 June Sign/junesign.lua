package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

function invert(obj)
local b=bbox(obj):extent()
local c=ccube(0.99*b)
c=translate(bbox(obj):center())*c
return difference(c,obj)
end

function getcat(zt)
local cat=load_centered_on_plate('cloud1.stl')
cat=intersection(cat,translate(0,-26,0)*cube(35,35,10))
cat=invert(cat)
cat=scale(1.4,1.4,zt/bbox(cat):extent().z)*cat
cat=translate(40,16,0)*cat
return cat
end

function getletters(zt)
local str='Unit'
local texth=10
local f=font(Path..'../ttf/Lato-Black.ttf')
local letters=jshapes.xycenter(f:str(str,1))
local e = bbox(letters):extent()
local factor = texth/e.y
letters=scale(factor,factor,zt/e.z)*letters
local l2=jshapes.xycenter(f:str('E',1))
e = bbox(l2):extent()
factor = texth*3/e.y
l2=scale(factor,factor,zt/e.z)*l2
l2=translate(0,-25,0)*l2
return union(letters,l2)
end

function mirrorx(obj)
return union(obj,mirror(v(1,0,0))*obj)
end



layerh=0.2
basethickness=5*layerh
topthickness=4*layerh

set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',layerh)
set_setting_value('z_layer_height_mm',layerh)
set_setting_value('gen_supports',false)
set_setting_value('infill_percentage_0',5)
set_setting_value('infill_percentage_1',5)
set_setting_value('FilamentSwapLayer',5)


cat=getcat(topthickness)
letters=getletters(topthickness)
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



