package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")
jtags=require("jtags")

tag=jtags.nametag('Griff','griffbw.jpegW24H25T3V4B2A0C0NS.stl')


l=cube(5,5,5)

set_brush_color (1,1,1,1)
emit(tag,1)
set_brush_color (2,0,0,0)
emit(l,2)


    --text='Griff'
    --image='griffbw.jpegW24H25T3V4B2A0C0NS.stl'
    