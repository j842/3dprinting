-- Bike clamp (Tetrarack M2, with Enfitnix Cubelite II)
-- one unit is 1mm

-- overall height - needs to be 24mm for holder to fit light
height=24

-- how thick the bar it attaches to is, and how thick to make clamping ring
barr=19/2
ringthick=5

-- how far mounts stick out, depth of slot for the two parts to fit together
mountl1=5
mountl2=10
slotl=10

-- width of mounts and slot.
mountw=15
slotw=7

-- size of holes for zip ties
zipl=4
ziph=2

-- small gap when cutting halves in two
gap=1


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


function zipmount2(xl,xr,xzip,ythick)
local smount=translate(xl+0.5*(xr-xl),0,0)*cube(xr-xl,ythick,height)
local ziphole1=translate(xzip,0,0.25*height-0.5*ziph)*cube(zipl,ythick,ziph)
local ziphole2=translate(xzip,0,0.75*height-0.5*ziph)*cube(zipl,ythick,ziph)

smount=difference(smount,ziphole1)
smount=difference(smount,ziphole2)

return smount
end


-- mounts
smount=zipmount2(ringedgex-mountoverlap,ringedgex+mountl1,ringedgex+0.5*zipl,mountw)

smount2=zipmount2(-ringedgex-mountl2,-ringedgex+mountoverlap,
                  -ringedgex-mountl2+0.5*slotl,mountw)

sslot=translate(0.5*slotl-ringedgex-mountl2,0,0)*
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

tempoffset=slotl/2
tempoffset=-slotl/2-1

-- tab
stab=cube(slotl,slotw-gap,height)
ziphol1=translate(0,0,0.25*height-0.5*ziph)*cube(zipl,slotw,ziph)
ziphol2=translate(0,0,0.75*height-0.5*ziph)*cube(zipl,slotw,ziph)
stab=difference(stab,ziphol1)
stab=difference(stab,ziphol2)
stab=translate(tempoffset,0,0)*stab
emit(stab)

-- light mount
lmthick=6
backthick=2
gapthick=2
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


-- adjust plate to attach, and off-center to look nice
yadjust=5
slmount=translate(-slotl+lmthick+tempoffset,yadjust,0)*slmount
emit(slmount)

-- add letters (40mm high, 10mm deep). Manually placed.
j=load('../letters/letter_j.stl')
e=load('../letters/letter_e.stl')
logo=scale(0.3)*mirror(v(1,0,0))*rotate(90,0,0)*union(j,translate(15,0,0)*e)
logo=rotate(0,90,0)*logo
logo=translate(31,15,5.5)*logo
emit(logo)

