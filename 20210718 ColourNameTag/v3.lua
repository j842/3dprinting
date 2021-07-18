local v3 = {}
-- lolin mcu v3 8266.

--------------------------------

function v3.boardsz()
    return v(31,58.5,1.5)
  end
  
  function v3.holesz()
    return v(25,52)
  end
  
  function v3.holeoff()
    return v(
      (v3.boardsz().x-v3.holesz().x)/2,
      (v3.boardsz().y-v3.holesz().y)/2
  )
  end
  
  function v3.usbsz()
     return v(8,6,3)
  end
  
  -- 25 between holes in x
  -- 52 between holes in y
  
  ----------------------------------------
  
  function v3.usbplug(elongate)
    local musbstickout=1.5
    local us=v3.usbsz()
    local musb=cube(us.x,us.y+elongate,us.z+v3.boardsz().z)
    musb=translate(0,musbstickout-us.y/2+v3.boardsz().y/2,-us.z)*musb
    return musb
  end
  
  function v3.template()
    -- ESP-8266 Lolin NodeMCU v3 board
    local w=v3.boardsz().x
    local l=v3.boardsz().y
    local boardthickness=v3.boardsz().z
    local pinheight=9
    local clearance=4
  
    local board=cube(w,l,boardthickness)
  
    local musb=v3.usbplug(0)
    board=union(board,musb)
  
    local esp8266=
      translate(0,-13.7,-v3.usbsz().z)*
      cube(13,16,clearance)
    board=union(board,esp8266)
  
    local hole=cylinder(3/2,boardthickness)
    hole=translate(
      -w/2+v3.holeoff().x,
      -l/2+v3.holeoff().y,
      0)*hole
    hole=union(hole,mirror(v(1,0,0))*hole)
    hole=union(hole,mirror(v(0,1,0))*hole)
    board=difference(board,hole)
  
    return board
  end
  
  ----------------------------------------
  
  
  function v3.getpincircle(r,z)
    local set={}
    local j
    local c=50
    for j=1,c do
      local jj=2*3.14*(j-1)/(c-1)
      table.insert(set,v(r*math.cos(jj),r*math.sin(jj),z))
    end
    return set
  end
  
  function v3.getpin(r,h,t)
    local set={}
    local o=.3
    local op=5
    local f=0.2
    local l=f+op*o
    table.insert(set,v3.getpincircle(r+2*o,0))
    table.insert(set,v3.getpincircle(r+3*o,h-op*o))
    table.insert(set,v3.getpincircle(r+2*o,h-f))
    table.insert(set,v3.getpincircle(r,h))
    table.insert(set,v3.getpincircle(r,h+t))
    local se = sections_extrude(set)
    return se
  end
  
  ----------------------------------------
  
  function v3.getrect(dx,dy,z)
    return {v(0,0,z),v(dx,0,z),v(dx,dy,z),v(0,dy,z)}
  end
  
  function v3.getclip(baset,h,t)
    local set={}
    local cy=4
    local cx=1.4*baset
    table.insert(set, v3.getrect(2*baset,cy,0))
    table.insert(set, v3.getrect(2*baset,cy,baset))
    table.insert(set, v3.getrect(baset,cy,h/2+baset/2)) -- half way between baset and h.
    table.insert(set, v3.getrect(baset,cy,h+t+0.1))
    table.insert(set, v3.getrect(cx,cy,h+t+0.3))
    table.insert(set, v3.getrect(baset,cy,h+t+baset*2))
    local se =  jshapes.xycenter(sections_extrude(set))
     
    se=union(se,translate(-baset/2,0,0)*cube(baset,cy*1.15,h+t+baset*2))
    se=rotate(-90,Z)*se
    return se
  end
  
  ----------------------------------------
  
  function v3.dualmirror(obj)
    obj=union(obj,mirror(v(1,0,0))*obj)
    obj=union(obj,mirror(v(0,1,0))*obj)
    return obj
  end
  
  ----------------------------------------
  
  
  function v3.mount(h)
    local ls=v3.boardsz()
    local se = v3.getpin(3/2,h,ls.z)
    se=translate(
      -ls.x/2+v3.holeoff().x,
      -ls.y/2+v3.holeoff().y,0)*se
    se=v3.dualmirror(se)
  
    local asymbackplate=0.4 --the side opposite the USB connector is a bit smaller (assymetrical)
  
    local baset=2
    local sideclip=v3.getclip(baset,h,ls.z)
    local cxt=2
    sideclip=translate(  
      ls.x/2-3*v3.holeoff().x,
      ls.y/2,
      0)*sideclip
    sideclip=union(sideclip,mirror(v(1,0,0))*sideclip)
    sideclip=union(sideclip,translate(0,asymbackplate,0)*mirror(v(0,1,0))*sideclip)
    --sideclip=dualmirror(sideclip)--union(sideclip,mirror(v(1,0,0))*sideclip)
    se=union(se,sideclip)
  
    local cc=cube(ls.x,ls.y,baset)
    cc=difference(cc,scale((ls.x-2*baset)/ls.x,(ls.y-2*baset)/ls.y,1)*cc)
    se=union(se,cc)
  
    local backplate=translate(0,ls.y/2+baset/2,0)*cube(ls.x,baset,ls.z+h)
    se=union({se, backplate,
      translate(0,asymbackplate,0)*mirror(v(0,1,0))*backplate})
    se=difference(se,translate(0,0,h)*v3.usbplug(baset))
  
    return se
  end
  
  ----------------------------------------


return v3

  