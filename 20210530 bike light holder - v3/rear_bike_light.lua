-- Bike clamp (Tetrarack M2, with Enfitnix Cubelite II)
-- one unit is 1mm

package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

-- overall height - needs to be 24mm for holder to fit light
height=24

-- how thick the bar it attaches to is, and how thick to make clamping ring
barr=19/2
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
  local b1=jshapes.m4(v(vec.x,vec.y,vec.z),v(vec.x,-vec.y,vec.z),bolts,true)
  vec.z=0.75*height
  local b2=m4(v(vec.x,vec.y,vec.z),v(vec.x,-vec.y,vec.z),bolts,true)

  sring=difference(sring,b1)
  sring=difference(sring,b2)

  return sring
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
  cylinder(barr,height)
)

-- add groves to match raised parts of Tetrapack bar (probably not needed)
sring=difference(
  sring,
  translate(0,0,height/2+17/2)*cylinder(barr+2,1))
sring=difference(
  sring,
  translate(0,0,height/2-17/2)*cylinder(barr+2,1))

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

-- light mount, with left edge at x=0
lmthick=6
backthick=2
gapthick=2
lml=29
edget=3
edgetsmall=1
slmount=cube(lmthick,lml,height)
slmount=translate(-lmthick*0.5,0,0)*slmount

-- cut out main recess
cutoutl1=lmthick-backthick
slmount=difference(slmount,
  translate(-backthick-0.5*cutoutl1,0.5*edget,edget)*
  cube(cutoutl1,lml-edget,height-2*edget))

-- cut out small slot the light slides in
slmount=difference(slmount,
  translate(-backthick-0.5*gapthick,0.5*gapthick,gapthick)*
  cube(gapthick,lml-gapthick,height-2*gapthick))

-- remove more of slot region (so grab area is smaller)
ridgel=25
slmount=difference(slmount,
  translate(-backthick-0.5*(lmthick-backthick),0.5*ridgel,0)*
  cube(lmthick-backthick,lml-ridgel,height)
)

-- create push tab
lmtabh=9

-- add cutouts so push tab can flex
tabcutl=10
tabcuth=1
slmount=difference(slmount,
  translate(-0.5*lmthick,0.5*(lml),0.5*(height+lmtabh)-0.5*tabcuth)*
  cube(lmthick,tabcutl,tabcuth)
)
slmount=difference(slmount,
  translate(-0.5*lmthick,0.5*(lml),0.5*(height-lmtabh)-0.5*tabcuth)*
  cube(lmthick,tabcutl,tabcuth)
)

-- add the little bump to lock in place
bumpdown=26.5
slmount=union(slmount,
  translate(-0.5 -backthick,-0.5*lml+bumpdown,(height-4)/2)*
  cube(1,1,4)
)

-- adjust plate to attach, and off-center to look nice
yadjust=0
slmount=translate(0,yadjust,0)*slmount

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


