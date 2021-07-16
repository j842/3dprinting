

function lolinsize()
  return v(31,57.5,1.5)
end

----------------------------------------

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

----------------------------------------


function getset(r,z)
  local set={}
  local j
  local c=50
  for j=1,c do
    local jj=2*3.14*(j-1)/(c-1)
    table.insert(set,v(r*math.cos(jj),r*math.sin(jj),z))
  end
  return set
end

function getclip(r,h,t)
  local set={}
  local o=.3
  local op=5
  local f=0.2
  local l=f+2*op*o
  table.insert(set,getset(r,0))
  table.insert(set,getset(r,h-op*o))
  table.insert(set,getset(r+o,h-f))
  table.insert(set,getset(r,h))
  table.insert(set,getset(r,h+t))
  table.insert(set,getset(r+o,h+t+f))
  table.insert(set,getset(r,h+t+f+op*o))
  table.insert(set,getset(r,h+t+l))
  
  se = sections_extrude(set)
  se = difference(se,
        translate(0,0,h+t/2-l)*
        cube(o*op,(r+o)*2,2*l+t)
        )

return se
end

function lolinv3mount(h)
local ls=lolinsize()
local se = getclip(3/2,h,ls.z)
--set_brush_color (3,0,0,1)
se=translate(-ls.x/2+2.3,-ls.y/2+2.3,0)*se
se=union(se,mirror(v(1,0,0))*se)
se=union(se,mirror(v(0,1,0))*se)

baset=1
--se=translate(0,0,baset)*se
se=union(se,cube(ls.x,ls.y,baset))
return se
end

----------------------------------------


-- MAIN

h=5
mnt=lolinv3mount(h)
set_brush_color(1,0,1,0)
emit(mnt,1)

y=translate(0,0,0.8)*rotate(180,X)*load('NodeMcu_V3.stl')
y=translate(0,0,h)*y
set_brush_color (2,1,0,0)
emit(y,2)

x=lolinv3template()
x=translate(0,0,h)*x
set_brush_color (3,1,0,1)
emit(x,3)






