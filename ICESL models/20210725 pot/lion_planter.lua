-- Lion Planter

printplanter=true
printbase=false

---------------------------------------

-- print settings
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.3)
set_setting_value('gen_supports',false)
set_setting_value('add_brim',false)

set_brush_color (0,.1,.5,.5)
set_setting_value('infill_percentage_0',5)
set_setting_value('cover_thickness_mm_0',1.5)

set_brush_color(1,0,1,0)
set_setting_value('infill_percentage_1',100)
set_setting_value('cover_thickness_mm_0',1.2)

----------------------------------------------

-- Load the planeter model

sbox=load_centered_on_plate('pot.stl')
-- 1.0 = small, 1.25 = medium, 1.5 = large
sboxsize=1.0
sbox=scale(sboxsize)*sbox


-- Base for planter

function sbase(off,z,ss)
  local w=2*off+ss.x
  local ws=2*off+ss.y-ss.x
  local base=cube(w,w,z)
  local r=4*ws/6
  base=union(
    translate(0,(ss.y-ss.x)/2,0)*base,
    translate(0,-ss.x/2,0)*
      intersection(
        cube(ws,ws,z),
        translate(0,-ws/2+r,0)*cylinder(r,z)
      )
  )
  return base
end

ss=bbox(sbox):extent()
halfthick=2.1
gap=0.5
base=difference(
  sbase(halfthick+gap,2*halfthick,ss),
  translate(0,0,halfthick)*sbase(gap,halfthick,ss)
)
-------------------------------------------------

function spout(ws,h)
  local r=4*ws/6
  return intersection(
        cube(ws,ws,h),
        translate(0,-ws/2+r,0)*cylinder(r,h)
      )
end

function flion(sc)
  local lpot=load_centered_on_plate('pot.stl')
  local l=intersection(lpot,
    translate(0,-40,34)*cube(40,29,38))
  l=scale(sc)*l
  l=translate(-bbox(l):min_corner().x-bbox(l):extent().x/2,-bbox(l):max_corner().y,0)*l
  return l
end

function leafy(sc)
  local lpot=load_centered_on_plate('pot.stl')
  local l=intersection(lpot,
    translate(-28,-26,13)*cube(18,1,54))
  l=scale(sc,4,sc)*l
  l=translate(-bbox(l):min_corner().x-bbox(l):extent().x/2,-bbox(l):max_corner().y,0)*l
  return l
end   

function newpot(sc)
  local w=80*sc
  local ws=30*sc
  local h=80*sc
  local hspout=35*sc
  local wt=7
  local base=difference(
    cube(w,w,h),
    translate(0,0,wt)*cube(w-wt,w-wt,h-wt))
  
  sp=difference(
    translate(0,wt/2,0)*spout(ws,hspout),
    translate(0,wt/2,wt)*spout(ws-wt,hspout-wt))

  newp=union(
    translate(0,ws/2,0)*base,
    translate(0,-w/2,0)*
    sp
  )

  local lion=translate(0,-25*sc,2)*flion(sc)
  newp=union(newp,lion)

  local leaf=translate(-28*sc,-24.5*sc,0)*leafy(sc)
  leaf=union(leaf,mirror(X)*leaf)
  newp=union(newp,leaf)
  newp=difference(newp,translate(0,80*sc,0)*leaf)

  newp=difference(newp,
    union(
    translate(0,-30,wt)*cube(20,20,10),
    translate(0,-20,wt+10)*rotate(90,X)*cylinder(10,5)
)
)

  return newp
end

newp=translate(0,100,0)*rotate(90,Z)*newpot(1.0)
emit(newp)


-- rotate so can print big

base=rotate(90,Z)*base

if (printbase) then
  -- move planter above base.
  sbox=translate(0,0,halfthick)*sbox
end
sbox=rotate(90,Z)*sbox

-- emit parts
-- base
if (printbase) then
  emit(base,1)
end
-- planter
if (printplanter) then
  emit(sbox,0)
end


