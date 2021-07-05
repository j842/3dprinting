  package.path = package.path .. ";../common/?.lua"
  jshapes=require("jshapes")
  jtags2=require("jtags2")
  
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
  text='AGNETHA'
  image='_agnetha.jpgW25H25T3V4B2A0C0NS.stl'
  tag=jtags2.nametag(text,image)
  
  hold=jtags2.holder()
  
  debug=false
  if (debug) then
    tmatrix=snap(hold,'h1',tag,'t1')
    set_brush_color (1,1,1,1)
    emit(tmatrix*tag,1)
    set_brush_color (2,0,0,0)
    emit(hold,2)
  else
    tag=rotate(90,Z)*tag
    emit(tag)
    hold=translate(bbox(hold):extent().y,0,0)*jshapes.xycenter(rotate(90,Z)*rotate(90,X)*hold)
    emit(hold)
  end
  
