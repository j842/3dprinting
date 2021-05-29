-- one unit is 1mm

height=24

barr=19/2
ringthick=5

mountl1=5
mountl2=10
slotl=10

mountw=15
slotw=7

mountoverlap=0.5*ringthick

ringedgex=barr+ringthick

zipl=2
ziph=4

gap=1

-- ring shape

sring=difference(
  cylinder(ringedgex,height),
  cylinder(barr,height)
)


-- tab with zip mount, custom length
function zipmount(ll,zipoffset)
local mountltot=ll+mountoverlap
local smount = translate(ringedgex+0.5*mountltot-mountoverlap,0,0) *
             cube(mountltot,mountw,height)

local zipslotdx=-0.5*zipl + ringedgex + ll - zipoffset
local szipslot = translate(zipslotdx,
              0,0.5*height-0.5*ziph) *
            cube(zipl,mountw,ziph)

return difference(
  smount,
  szipslot
)
end



-- mounts
smount=zipmount(mountl1,mountl1/2)

smount2 = mirror(v(1,0,0))*zipmount(mountl2,slotl/2)
sslot=translate(-0.5*slotl-ringedgex-mountl2+slotl,0,0)*
         cube(slotl,slotw,height)
smount2=difference(smount2,sslot)

-- cut slot

barmount=union(union(sring,smount),smount2)

barmount=difference(barmount,
  cube(2*(barr+ringthick+mountl2),gap,height))

-- just shift out of the way of the other piece
--barmount=translate(barr+ringthick+mountl2+slotl,0,0)*barmount
barmount=translate(barr+ringthick+mountl2,0,0)*barmount

emit(barmount)

-------------------------------------------------------
------------ PART 2 - light holder --------------------
-------------------------------------------------------

--tempoffset=slotl/2
tempoffset=-slotl/2-1

-- tab
stab=cube(slotl,slotw,height)
szipslot3=translate(0.5*zipl,0,0.5*height-0.5*ziph)*
  cube(zipl,slotw,ziph)
stab=difference(stab,szipslot3)
stab=translate(tempoffset,0,0)*stab
emit(stab)

-- light mount
lmthick=5
backthick=2
gapthick=1.5
lml=37
edget=3
edgetsmall=1
slmount=cube(lmthick,lml,height)
slmount=translate(-lmthick*0.5,0,0)*slmount
--slmount=translate(-lmthick*0.5,-lml*0.5,0)*slmount

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
lmtabl=8
slmount=difference(slmount,
  translate(-0.5*lmthick,0.5*(lml-lmtabl),0)*
  cube(lmthick,lmtabl,0.5*(height-lmtabh))
)
slmount=difference(slmount,
  translate(-0.5*lmthick,0.5*(lml-lmtabl),height-0.5*(height-lmtabh))*
  cube(lmthick,lmtabl,0.5*(height-lmtabh))
)

-- add cutouts so push tab can flex
tabcutl=20
tabcuth=1
slmount=difference(slmount,
  translate(-0.5*lmthick,0.5*(lml-lmtabl),0.5*(height+lmtabh)-0.5*tabcuth)*
  cube(lmthick,tabcutl,tabcuth)
)
slmount=difference(slmount,
  translate(-0.5*lmthick,0.5*(lml-lmtabl),0.5*(height-lmtabh)-0.5*tabcuth)*
  cube(lmthick,tabcutl,tabcuth)
)

-- add the little bump to lock in place
bumpdown=25
slmount=union(slmount,
  translate(-0.5 -backthick,-0.5*lml+bumpdown,(height-4)/2)*
  cube(1,1,4)
)




-- adjust off-center so it fits solidly on the mount tab (full overlap)
yadjust=0
slmount=translate(-slotl+tempoffset+lmthick,yadjust,0)*slmount
emit(slmount)




