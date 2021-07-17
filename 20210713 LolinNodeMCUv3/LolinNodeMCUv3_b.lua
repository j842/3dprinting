package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

function lolinsize()
  return v(31,57.5,1.5)
end

function holesize()
  return v(25,52)
end

function holeoffset()
  return v(
    (lolinsize().x-holesize().x)/2,
    (lolinsize().y-holesize().y)/2
)
end

-- 25 between holes in x
-- 52 between holes in y

----------------------------------------

function lolinv3template()
  -- ESP-8266 Lolin NodeMCU v3 board
  local w=lolinsize().x
  local l=lolinsize().y
  local boardthickness=lolinsize().z
  local pinheight=9
  local clearance=4
  local musbh=3
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
  hole=translate(
    -w/2+holeoffset().x,
    -l/2+holeoffset().y,
    0)*hole
  hole=union(hole,mirror(v(1,0,0))*hole)
  hole=union(hole,mirror(v(0,1,0))*hole)
  board=difference(board,hole)

  return board
end

----------------------------------------


function getpincircle(r,z)
  local set={}
  local j
  local c=50
  for j=1,c do
    local jj=2*3.14*(j-1)/(c-1)
    table.insert(set,v(r*math.cos(jj),r*math.sin(jj),z))
  end
  return set
end

function getpin(r,h,t)
  local set={}
  local o=.3
  local op=5
  local f=0.2
  local l=f+op*o
  table.insert(set,getpincircle(r+2*o,0))
  table.insert(set,getpincircle(r+3*o,h-op*o))
  table.insert(set,getpincircle(r+2*o,h-f))
  table.insert(set,getpincircle(r,h))
  table.insert(set,getpincircle(r,h+t))
  local se = sections_extrude(set)
  return se
end

----------------------------------------

function getrect(dx,dy,z)
  return {v(0,0,z),v(dx,0,z),v(dx,dy,z),v(0,dy,z)}
end

function getclip(baset,h,t)
  local set={}
  local cy=4
  local cx=2*baset
  table.insert(set, getrect(cx,cy,0))
  table.insert(set, getrect(cx,cy,cx/2))
  table.insert(set, getrect(cx/2,cy,h/2+cx/4)) -- half way between cx/2 and h.
  table.insert(set, getrect(cx/2,cy,h+t-0.01))
  table.insert(set, getrect(cx,cy,h+t))
  table.insert(set, getrect(cx/2,cy,h+t+baset*2))
  local se = sections_extrude(set)
  return jshapes.xycenter(se)
end

----------------------------------------

function dualmirror(obj)
  obj=union(obj,mirror(v(1,0,0))*obj)
  obj=union(obj,mirror(v(0,1,0))*obj)
  return obj
end

----------------------------------------


function lolinv3mount(h)
  local ls=lolinsize()
  local se = getpin(3/2,h,ls.z)
  se=translate(
    -ls.x/2+holeoffset().x,
    -ls.y/2+holeoffset().y,0)*se
  se=dualmirror(se)

  local baset=2
  local sideclip=getclip(baset,h,ls.z)
  local cxt=2
  sideclip=translate(  
    -ls.x/2,
    -ls.y/2+2.5*holeoffset().y,
    0)*sideclip
  sideclip=dualmirror(sideclip)
  se=union(se,sideclip)

  local cc=cube(ls.x,ls.y,baset)
  cc=difference(cc,scale((ls.x-2*baset)/ls.x,(ls.y-2*baset)/ls.y,1)*cc)
  se=union(se,cc)
  return se
end

----------------------------------------


-- MAIN
function main()
  local h=5
  local mnt=lolinv3mount(h)
  set_brush_color(1,0,1,0)
  emit(mnt,1)

  local y=translate(0,0,0.8)*rotate(180,X)*load('NodeMcu_V3.stl')
  y=translate(0,0,h)*y
  set_brush_color (2,1,0,0)
  --emit(y,2)

  local x=lolinv3template()
  x=translate(0,0,h)*x
  set_brush_color (3,1,0,1)
  --emit(x,3)
end


----------------------------------------
main()


