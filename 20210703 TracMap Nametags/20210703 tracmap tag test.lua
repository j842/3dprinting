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
    -- make hole for led cable
    h=difference(h,translate(-hs.x/2+16,-hs.y/2+g,g)*cube(10,2*g,2))

    -- add tracmap logo on top
    tracmap=load_centered(Path..'Main-TracMap-Logo-GreenBlue-Clear.pngW40H9T3V4B2A0C0NS.stl')
    tracmap=mirror(v(1,0,0))*rotate(180,X)*jshapes.xycenter(tracmap)
    tbox=bbox(tracmap):extent()
    tracmap=translate(0,0,hs.z-tbox.z)*jshapes.xycenter(tracmap)
    h=difference(h,translate(0,0,hs.z-tbox.z)*cube(tbox))
    h=union(h,tracmap)
    local dy=(hs.y-tbox.y)/2
    h=union(h,translate(0,-dy,hs.z-tbox.z)*cube(tbox.x,dy,tbox.z))


    h=union(h,translate(0,hs.y/2-g-ts.y/2,g)*magnet('h1'))
    return h

end

tag=jtags.nametag('Griff','griffbw.jpegW24H25T3V4B2A0C0NS.stl')

hold=holder()

debug=false
if (debug) then
  tmatrix=snap(hold,'h1',tag,'t1')
  set_brush_color (1,1,1,1)
  emit(tmatrix*tag,1)
  set_brush_color (2,0,0,0)
  emit(hold,2)
else
  --emit(tag)
  hold=translate(0,bbox(hold):extent().y,0)*jshapes.xycenter(rotate(90,X)*hold)
  emit(hold)
end


    --text='Griff'
    --image='griffbw.jpegW24H25T3V4B2A0C0NS.stl'
    