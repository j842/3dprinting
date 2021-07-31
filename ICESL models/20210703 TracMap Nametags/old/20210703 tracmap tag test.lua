package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")
jtags=require("jtags")

-- when printing nametag:
-- first layer 0.3mm, others 0.1mm

-- 20% infill is fine for both

-- https://3dp.rocks/lithophane/
-- Model settings:
-- Max Size (mm)  25
-- Thickness 3.5
-- Border 2
-- Thinnest layer 0.5
-- Positive image
text='DaxWax'
image='_daxwax.jpgW25H25T3V4B2A0C0NS.stl'
tag=jtags.nametag(text,image)

hold=jtags.holder()

debug=false
if (debug) then
  tmatrix=snap(hold,'h1',tag,'t1')
  set_brush_color (1,1,1,1)
  emit(tmatrix*tag,1)
  set_brush_color (2,0,0,0)
  emit(hold,2)
else
  emit(tag)
  hold=translate(0,bbox(hold):extent().y,0)*jshapes.xycenter(rotate(90,X)*hold)
--  emit(hold)
end


    