package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")
jtags=require("jtags")

function holder()
    local g=jtags.gettagborder()
    local ts=jtags.gettagsize()
    local hs=v(ts.x+2*g,25,ts.z+g)
    local h=cube(hs)

    local feather=0.5
    -- remove slot for tag
    h=difference(h,translate(0,hs.y/2-ts.y/2-g,hs.z-ts.z)*cube(ts+v(feather,feather,0)))
    -- remove material in front of slot so you can see tag
    h=difference(h,translate(0,hs.y/2-ts.y/2,hs.z-ts.z+g)*cube(ts.x-2*g,ts.y,ts.z-g))
    -- remove material behind slot so light can get to it
    h=difference(h,translate(0,0,g)*cube(hs.x-2*g,hs.y-g-ts.y,hs.z-2*g))

    h=union(h,translate(0,hs.y/2-g-ts.y/2,g)*magnet('h1'))
    return h

end

tag=jtags.nametag('Griff','griffbw.jpegW24H25T3V4B2A0C0NS.stl')

hold=holder()

tmatrix=snap(hold,'h1',tag,'t1')
set_brush_color (1,1,1,1)
--emit(tmatrix*tag,1)
set_brush_color (2,0,0,0)
emit(hold,2)



    --text='Griff'
    --image='griffbw.jpegW24H25T3V4B2A0C0NS.stl'
    