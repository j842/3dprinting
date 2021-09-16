  package.path = package.path .. ";../common/?.lua"
  jshapes=require("jshapes")
  jtags2=require("jtags2")
  
  -- when printing nametag:
  -- first layer 0.3mm, others 0.1mm
  
-- print settings
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.1)
--set_setting_value('gen_supports',true)
set_setting_value('gen_supports',false)
set_setting_value('infill_percentage_0',5)


  -- https://3dp.rocks/lithophane/
  -- Model settings:
  -- Max Size (mm)  25
  -- Thickness 3.5
  -- Border 2
  -- Thinnest layer 0.5
  -- Positive image
  text='MARK'
  image='_mark.jpgW25H25T3V4B2A0C0NS.stl'
  tag=jtags2.nametag(text,image)
  
  -- orientate around the Y axis
  --tag=rotate(90,Z)*tag
  
  -- orientate flat
  tag=rotate(90,X)*tag

  emit(tag)

