

function lolinsize()
  return v(31,57.5,1.5)
end

function lolinv3template()
-- ESP-8266 Lolin NodeMCU v3 board
local w=lolinsize().x
local l=lolinsize().y
local boardthickness=lolinsize().z
local pinheight=9
local clearance=4
local musbh=3.5
local musbw=8
local musbl=6
local musbstickout=1.5

local board=cube(w,l,boardthickness)

local musb=cube(musbw,musbl,musbh)
musb=translate(0,musbstickout-musbl/2+l/2,-musbh)*musb
board=union(board,musb)

local esp8266=
  translate(0,-13.7,-musbh)*
  cube(13,16,clearance)
board=union(board,esp8266)

local hole=cylinder(3/2,boardthickness)
hole=translate(-w/2+2.3,-l/2+2.3,0)*hole
hole=union(hole,mirror(v(1,0,0))*hole)
hole=union(hole,mirror(v(0,1,0))*hole)
board=difference(board,hole)

return board
end

function lolinv3mount(h)
local ls=lolinsize()

local hole=union(
  cylinder(3/2,h),
  translate(0,0,h)*cylinder(2.8/2,ls.z+3)
)

hole=translate(-ls.x/2+2.3,-ls.y/2+2.3,0)*hole
hole=union(hole,mirror(v(1,0,0))*hole)
hole=union(hole,mirror(v(0,1,0))*hole)
return hole
end


mountheight=4
mnt=lolinv3mount(mountheight)
set_brush_color(1,0,1,0)
emit(mnt,1)


--x=rotate(180,X)*lolinv3template()
x=translate(0,0,mountheight)*lolinv3template()

--y=load('NodeMcu_V3.stl')
--emit(y)

set_brush_color (2,1,0,0)
emit(x,2)