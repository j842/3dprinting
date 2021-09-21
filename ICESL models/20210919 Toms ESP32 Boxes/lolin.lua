local lolin = {}

----------------------------------------------------



-- ESP8266MOD ver 0.1 "new NodeMcu V3"

function lolinsize()
    return v(30.85,57.4,1.55)
  end
  
  function holedist()
  -- radius 3.2mm
  -- 25 between holes in x
  -- 52 between holes in y
    return v(22+3.2,48.8+3.2)
  end
  
  function holeoffset()
    return v(
      (lolinsize().x-holedist().x)/2,
      (lolinsize().y-holedist().y)/2
  )
  end
  
  function usbsize()
     return v(8,6,3)
  end
  

  function delta()      -- delta is the gap/tolerance for clips
      return 0.5
  end
  
  ----------------------------------------
  
  function usbplug(elongate)
    local musbstickout=1.5
    local us=usbsize()
    local musb=cube(us.x,us.y+elongate,us.z+lolinsize().z)
    musb=translate(0,musbstickout-us.y/2+lolinsize().y/2,-us.z)*musb
    return musb
  end
  
  function lolin.lolinv3template()
    -- ESP-8266 Lolin NodeMCU v3 board
    local w=lolinsize().x
    local l=lolinsize().y
    local boardthickness=lolinsize().z
    local pinheight=9
    local clearance=4
  
    local board=cube(w,l,boardthickness)
  
    local musb=usbplug(0)
    board=union(board,musb)
  
    local esp8266=
      translate(0,-13.7,-usbsize().z)*
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
  

    -- center in x and y, and place on z=0 surface.
   function xycenter(objtocenter)
    local v=bbox(objtocenter):center()
    objtocenter=translate(-v.x,-v.y,-v.z)*objtocenter
    local h=bbox(objtocenter):min_corner().z
    return translate(0,0,-h)*objtocenter
  end
  ----------

  function getclip(baset,h,t)
    local set={}
    local cy=4
    local cx=baset+delta()+0.5
    local aboveboard=h+t+0.05
    local maxh=aboveboard+2*(cx-baset)
    table.insert(set, getrect(2*baset,cy,0))
    table.insert(set, getrect(2*baset,cy,baset))
    table.insert(set, getrect(baset,cy,h/2+baset/2)) -- half way between baset and h.
    table.insert(set, getrect(baset,cy,aboveboard))
    table.insert(set, getrect(cx,cy,aboveboard+cx-baset))
    table.insert(set, getrect(baset,cy,maxh))
    local se =  translate(-baset,-cy/2,0)*sections_extrude(set)
     
    se=union(se,translate(-baset/2,0,0)*cube(baset,cy*1.15,maxh))
    se=rotate(-90,Z)*se
    return se
  end
  
  ----------------------------------------
  
  function dualmirror(obj)
    obj=union(obj,mirror(v(1,0,0))*obj)
    obj=union(obj,mirror(v(0,1,0))*obj)
    return obj
  end
  
  ----------------------------------------
  
  
  function lolin.lolinv3mount(h)
    local ls=lolinsize()
    holer=3.2
    holedelta=0.2
    local se = getpin((holer-holedelta)/2,h,ls.z)
    se=translate(
      -ls.x/2+holeoffset().x,
      -ls.y/2+holeoffset().y,0)*se
    se=dualmirror(se)
  
    local baset=2
    local sideclip=getclip(baset,h,ls.z)
    local cxt=2
    sideclip=translate(  
      ls.x/2-3*holeoffset().x,
      ls.y/2+delta(),
      0)*sideclip
    sideclip=union(sideclip,mirror(v(1,0,0))*sideclip)
    sideclip=union(sideclip,mirror(v(0,1,0))*sideclip)
    --sideclip=dualmirror(sideclip)--union(sideclip,mirror(v(1,0,0))*sideclip)
    se=union(se,sideclip)
  
    local cc=cube(ls.x,ls.y+2*delta(),baset)
    cc=difference(cc,scale((ls.x-2*baset)/ls.x,(ls.y-2*baset)/ls.y,1)*cc)
    se=union(se,cc)
  
    local backplate=translate(0,ls.y/2+baset/2+delta(),0)*cube(ls.x,baset,ls.z+h)
    se=union({se, backplate,
      mirror(v(0,1,0))*backplate})
    se=difference(se,translate(0,2*delta(),h)*usbplug(baset))
  
    return se
  end
  



----------------------------------------------------

return lolin
