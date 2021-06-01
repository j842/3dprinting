-- Bike clamp (Tetrarack M2, with Enfitnix Cubelite II)
-- one unit is 1mm

package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

-- overall height - needs to be 24mm for holder to fit light
height=25

-- how thick the bar it attaches to is, and how thick to make clamping ring
barr=19/2
pad=1

ringthick=5.5

-- how far mounts stick out, depth of slot for the two parts to fit together
mountl=10

-- width of mounts and slot.
thickness=17.5


-- create full height block from xl to xr, with thickness ythick, and bolts at xboltpos.
function addboltedtab(sring, xl,xr,xboltpos,ythick)
  local bolts=15

  sring=union(sring, translate(xl+0.5*(xr-xl),0,0)*cube(xr-xl,ythick,height))

  local vec=v(xboltpos,ythick/2,0.25*height)
  local b1=jshapes.m4rn(v(vec.x,vec.y,vec.z),v(vec.x,-vec.y,vec.z),bolts)
  vec.z=0.75*height
  local b2=jshapes.m4rn(v(vec.x,vec.y,vec.z),v(vec.x,-vec.y,vec.z),bolts)

  sring=difference(sring,b1)
  sring=difference(sring,b2)

  return sring
end

function tcube(dx,dy,dz)
   local tc=translate(0.5*dx,0.5*dy,0)*cube(dx,dy,dz)
   return tc
end

----------------------------------------------------

-------------------------------------------------------
------------ PART 1 - clamp        --------------------
-------------------------------------------------------

mountoverlap=0.5*ringthick
ringedgex=barr+ringthick

-- ring shape
sring=difference(
  cylinder(ringedgex,height),
  cylinder(barr+pad,height)
)

-- add groves to match raised parts of Tetrapack bar (probably not needed)
local notchgap=17
sring=difference(
  sring,
  translate(0,0,height/2+notchgap/2)*cylinder(barr+pad+2,1))
sring=difference(
  sring,
  translate(0,0,height/2-notchgap/2)*cylinder(barr+pad+2,1))

-- add in the mounts, passing in the current shape so we cut through everything for bolts
btx0=ringedgex-mountoverlap
btx1=ringedgex+mountl
btbp=ringedgex+mountl/2-2
sring=addboltedtab(sring,btx0,btx1,btbp,thickness)
sring=addboltedtab(sring,-btx1,-btx0,-btbp,thickness)

tx=10
ty=10
olap=2.5
edgecut=translate(ringedgex+mountl+0.5*tx-olap,thickness/2+0.5*ty-olap,0)*
      rotate(45,v(0,0,1))*cube(tx,ty,height)
sring=difference(sring,edgecut)
--sring=difference(sring,mirror(v(0,0,1))*zzz)


-- shift so right edge of tab is at x=0.
barmount=translate(barr+ringthick+mountl,0,0)*sring

-- add letters (40mm high, 10mm deep). Manually placed.
j=load('../letters/letter_j.stl')
e=load('../letters/letter_e.stl')
logo=scale(0.3)*mirror(v(1,0,0))*rotate(90,0,0)*union(j,translate(15,0,0)*e)
logo=rotate(0,90,0)*logo
logo=translate(31.5,15.5,5.5)*logo

barmount=union(barmount,logo)

-------------------------------------------------------
------------ PART 2 - light holder --------------------
-------------------------------------------------------

-- light mount, with (0,0,0) being (back,bottom,left) - extending in the +ve direction on all axes
slotw=20      -- how wide the slot that the light goes in
slotl=23      -- length of slot
slotd=2       -- depth of slot
overhangw=1   -- width of overhang of the ridge holding the light in
overhangl=1   -- length of overhang
overhangd=2   -- gap light goes in is 2mm deep

bumpl=24      -- how far is the bump from the back of slot

lml=29--29
backthick=2

sidethick=(height-slotw)/2         -- thickness of plastic around the notch (w and l directions)
backl=slotl+sidethick              -- total length of from start of slot to end of light mount
lmthick=backthick+slotd+overhangd  -- total thickness

-- main mount cube
slmount=tcube(lmthick,lml,height)

-- cut out main recess
slmount=difference(slmount,
  translate(backthick,sidethick+overhangl,sidethick+overhangw)*
  tcube(slotd+overhangd,slotl-overhangl,slotw-2*overhangw))

-- cut out thin slot the light slides in
slmount=difference(slmount,
  translate(backthick,sidethick,sidethick)*
  tcube(slotd,slotl,slotw))

-- remove the part beyond the slot
slmount=difference(slmount,
  translate(backthick,backl,0)*
  tcube(slotd+overhangd,lml-backl,height))

-- add cutouts so push tab can flex
tabw=9
tabg=1.5
tabover=2
slmount=difference(slmount,
  translate(0,backl-tabover,height/2-tabw/2-tabg/2)*
  tcube(lmthick,lml-backl+tabover,tabg))
slmount=difference(slmount,
  translate(0,backl-tabover,height/2+tabw/2-tabg/2)*
  tcube(lmthick,lml-backl+tabover,tabg))


-- add the little bump to lock in place
slmount=union(slmount,
  translate(backthick,backl,height/2-2)*
  tcube(1,1,4))

-- adjust plate to attach, and off-center to look nice
yadjust=-slotl/2
slmount=translate(0,yadjust,0)*slmount
slmount=mirror(v(1,0,0))*slmount

mount=union(barmount,slmount)

-------------------------------------------------------
------------ PART 3 - SPLIT FOR PRINTING --------------
-------------------------------------------------------

-- split it
ymax=ringedgex+10
xmax=2*(ringedgex+mountl)
-- halfcube extends from (-xmax,-ymax, 0) to (0, 0, height),
-- so represents the bottom (smaller) part of the bracket.
halfcube=translate(xmax/2,-.5*ymax,0)*cube(xmax,ymax,height)

mountbot=intersection(mount,halfcube)
mounttop=difference(mount,halfcube)

-- move bottom for printing
mountbot=translate(2,-6,0)*mountbot

-- emit the two halves
emit(mounttop)
emit(mountbot)


