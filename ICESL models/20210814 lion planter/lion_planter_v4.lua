-- Lion Planter

printplanter=false
printbase=true

--- Scale factor - determines size of lion.
  k=1.5
---


package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

---------------------------------------

-- print settings
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',false)
set_setting_value('add_brim',false)

-- planter brush
set_brush_color (0,.1,.3,.5)
set_setting_value('infill_percentage_0',100)
set_setting_value('cover_thickness_mm_0',1.2)

-- extra nodules brush (e.g. lion head)
set_brush_color(1,.1,.2,.5)
set_setting_value('infill_percentage_1',5)
set_setting_value('cover_thickness_mm_1',1.5)

-- base brush
set_brush_color(2,0,1,0)
set_setting_value('infill_percentage_2',100)
set_setting_value('cover_thickness_mm_2',1.2)


----------------------------------------------
--- 
  t=1.5+k/2
  embosst=0.6
  w=80
  h=k*80
  kw=k*w
  r=kw/6.5
----------------------------------------------


function flion(sc)
    local lhead=load_centered_on_plate('lionhead.stl')
    local lhe=bbox(lhead):extent()
    lhead=intersection(lhead,
      translate(0,0,3)*cube(lhe))
    lhead=jshapes.xycenter(lhead)
    lhead=scale(sc)*lhead
    return lhead
  end

  
function leafy(sc)
    local lpot=load_centered_on_plate('leaf.stl')
    lz=bbox(lpot):extent().z
    -- scale to 0.3mm thick
    lpot=scale(sc,sc,embosst/lz)*lpot
    return lpot
  end   


function getletters(str,zf)
    local texth=10*k
    local f=font(Path..'../ttf/Chocolate.ttf')
    local letters=jshapes.xycenter(f:str(str,1))
    local e = bbox(letters):extent()
    local factor = texth/e.y*zf
    letters=scale(factor,factor,embosst/e.z)*letters
    letters=rotate(90,X)*letters
    return letters
end


 -- baseshape, with walls adjusted by offset (inwards)
  function baseshape(off)
    local bs=union({
      translate(0,-kw/2,off)*cube(kw-2*off,kw-2*off,h-off),
      translate(0,r/2,off)*cube(2*r-2*off,r,h/3-off),
      translate(0,r,off)*cylinder(r-off,h/3-off)
    })
    return bs
  end

-- hole for water to go from spout to planter
  function spouthole()
    local shw=0.8*(2*r-2*t)
    local sht=t+1
    local shh=0.05*h/4
    local sh=union(
      translate(0,-t/2,t)*cube(shw,sht,shh),
      translate(0,0,t+shh)*
      rotate(90,X)*cylinder(shw/2,sht))

    sh=intersection(sh,
      translate(0,-sht/2,t)*cube(shw,sht,h/3))
    return sh
  end

  function cylinderz(a,kfac,aoff)
    local wf = 
      translate(0,-kw/2,0)*rotate(a+aoff,Z)*
      translate(0,-kfac*k,0)*cylinder(1.1*t,kw)
    return wf
  end


  function permeablebase()
    -- curved holed inside water filter bit
    local r0=kw/3
    local r1=kw
    local c0=v(0,0,t)
    local c1=v(0,0,t+r1-r0)
    local wf=difference(cone(r0,r1,c0,c1),cone(r0-t,r1-t,c0,c1))

    wf=intersection(wf,cube(kw-t/2,kw-t/2,h))
    wf=translate(0,-kw/2,0)*wf

    ad=360/10
    for a=0,360,ad do
      wf=difference(wf,cylinderz(a,26.2,0.5*ad))
      wf=difference(wf,cylinderz(a,30,0))
      wf=difference(wf,cylinderz(a,35,0.5*ad))
    end
    return wf
  end


--------------------------------------

  p=difference({baseshape(0),baseshape(t),spouthole()})

  p=union(p,permeablebase())

--------------------------------------

  -- lion
  pn=translate(0,0,2*h/3)*rotate(270,X)*rotate(180,Z)*flion(k)


  -- leaves (protruding on front)
  leaf=translate(28*k,0,h/2)*rotate(270,X)*rotate(180,Z)*leafy(k)
  leaf=union(leaf,mirror(X)*leaf)
  p=union(p,leaf)

  -- leaves (embossed on back and sides)
  leaf2=scale(0.45,1,0.3)*translate(0,-kw,0)*leaf
  p=difference(p,leaf2)

  -- side leaves
  leaf3=translate(kw/2,-kw/2,0)*rotate(90,Z)*leaf
  leaf3=union(leaf3,mirror(X)*leaf3)
  p=difference(p,leaf3)

-- letters on back

  letters=union({
      translate(0,-kw,1.5*15*k+kw/2)*
        getletters('Poipoia',1),
      translate(0,-kw,0.5*15*k+kw/2)*
        getletters('te   Kakano',0.6),
      translate(0,-kw,-0.6*15*k+kw/2)*
        getletters('Kia puawai',1)
  })


  p=union(p,letters)    


--------------------------------------------
  
  bs=baseshape(-t)
  be=bbox(bs):extent()
  bc=bbox(bs):center()
  b=difference(
    translate(bc.x,bc.y,0)*ccube(be.x+2*t,be.y+2*t,3*t),
    baseshape(-0.5)
  )

  b=intersection(b, baseshape(-2*t))

--------------------------------------------


  p=rotate(90,Z)*p
  b=rotate(90,Z)*b
  pn=rotate(90,Z)*pn

  if (printbase) then
    -- move planter above base.
    p=translate(0,0,t)*p
    pn=translate(0,0,t)*pn
  end

  if (printplanter) then
    emit(p,0)
    emit(pn,1)
  end
  if (printbase) then
    emit(b,2)
  end

  
