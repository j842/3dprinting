package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

---------------------------------------
w=225
t=11
x=20
h=154

flh=0.3
olh=0.2
baselayers=1+(t-flh)/olh

-- print settings
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',flh)
set_setting_value('z_layer_height_mm',olh)
set_setting_value('gen_supports',false)
set_setting_value('add_brim',false)

-- lid brush
set_brush_color (0,.1,.3,.5)
set_setting_value('infill_percentage_0',10)
set_setting_value('cover_thickness_mm_0',1.2)

-- Uncomment to swap filament
-- set_setting_value('FilamentSwapLayer',baselayers)


---------------------------------------

lid=cube(w,h,t)

----------------
knobsize=12
knob=translate(0,0,knobsize)*sphere(knobsize)
knob=difference(knob,
  translate(0,0,knobsize*1.5)*cube(2*knobsize,2*knobsize,knobsize))
knob=translate(0,h/2-1.5*knobsize,knobsize/2)*knob

lid=union(lid,knob)

----------------
cutaway=translate(0,h/2-t,0)*
  jshapes.xycenter(rotate(90,Y)*cylinder(t,w))
cutaway=difference(
  translate(0,h/2,0)*cube(w,t,t),cutaway)
-- should translate above by another -t/2, 
-- for perfect edge, but need to keep overhang okay

lid=difference(lid,cutaway)  
----------------

function getletters(zt)
  local str='30 Sheen St'
  local texth=20
  local f=font(Path..'../ttf/Lato-Black.ttf') 
  local letters=jshapes.xycenter(f:str(str,1))
  local e = bbox(letters):extent()
  local factor = texth/e.y
  letters=scale(factor,factor,zt/e.z)*letters
  return letters
end

lid=union(lid,translate(0,10,0)*rotate(180,Z)*getletters(t+2))

----------------

holepos=14+2
--hole=translate(w/2-5.5/2,-h/2+x,t/2-7/2)*cube(5.5,5.5,7)
hole=translate(w/2-5.5/2-40+holepos,-h/2+x,0)*cube(5.5,7,7/2+t/2)
hole=union(hole,
  translate(-w/2,-h/2+x,t/2)*rotate(90,Y)*cylinder(2.2,40))

hole=union(hole,mirror(X)*hole)
lid=difference(lid,hole)

----------------

lion=load_centered_on_plate('lionhead.stl')

lid=union(lid,
  translate(0,-30,t-3)*rotate(180,Z)*lion)


----------------



emit(lid)