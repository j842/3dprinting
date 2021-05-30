-- Bike clamp (Tetrarack M2, with Enfitnix Cubelite II)
-- one unit is 1mm

-- overall height - needs to be 24mm for holder to fit light
height=24

-- how thick the bar it attaches to is, and how thick to make clamping ring
barr=19/2
ringthick=5

-- how far mounts stick out, depth of slot for the two parts to fit together
mountl1=7
mountl2=10

-- width of mounts and slot.
mountw=15

-------------------------------------------------------
------------ Functions             --------------------
-------------------------------------------------------

----------------------------------------------------
-- create m4 recess. nyloc=true for nyloc nut.
function m4(vstart,vend,boltlength,isnyloc,swapends)
local headr=7/2
local headdepth=2.5
local shaftr=4/2
local holelength=length(vend-vstart)
local s=cylinder(shaftr,holelength)

if (holelength>boltlength) then
  headdepth=headdepth+holelength-boltlength
end
local h=cylinder(headr,headdepth)

local b=union(s,h)

local ndepth=3
if (isnyloc) then
  ndepth=4.5
end
local rt=math.sqrt(12)
local nut={ v{4,0,0},v{2,rt,0},v{-2,rt,0},v{-4,0,0},v{-2,-rt,0},v{2,-rt,0}}
local nuthole=linear_extrude(v(0,0,ndepth),nut)
nuthole=translate(0,0,holelength-ndepth)*nuthole

local assembly=union(b,nuthole)

-- vend at 0,0,0 currently, direction is -1.
avec=v(0,0,1)
local vnorm=normalize(vend-vstart)
local vc = cross(vnorm,avec)
local angle = -math.asin( length(vc))*180/3.141592654
if (swapends) then
    assembly=translate(0,0,holelength)*rotate(180,v(0,1,0))*assembly
end
assembly=rotate(angle,vc)*assembly

assembly=translate(vstart)*assembly
return assembly
end

-- create full height block from xl to xr, with thickness ythick, and zip tie holes at xzip.
function zipmount2(xl,xr,xscrewpos,ythick)
local smount=translate(xl+0.5*(xr-xl),0,0)*cube(xr-xl,ythick,height)
local vec=v(xscrewpos,-ythick/2,0.25*height)
smount=difference(smount,
m4(v(vec.x,vec.y,vec.z),v(vec.x,-vec.y,vec.z),15,true,true))
vec.z=0.75*height
smount=difference(smount,
m4(v(vec.x,vec.y,vec.z),v(vec.x,-vec.y,vec.z),15,true,true))
return smount
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

sring=difference(
  sring,
  translate(0,0,height/2+17/2)*cylinder(barr+2,1))
sring=difference(
  sring,
  translate(0,0,height/2-17/2)*cylinder(barr+2,1))

-- add in the mounts
-- the -1 x adjustment is because we're away from the peak of the circle
smount1=zipmount2(ringedgex-mountoverlap,ringedgex+mountl1,ringedgex+mountl1/2-1,mountw)

smount2=zipmount2(-ringedgex-mountl2,-ringedgex+mountoverlap+2,
                  -ringedgex-mountl2/2,mountw+5)

barmount=union(union(sring,smount1),smount2)

-- shift so right edge of tab is at x=0.
barmount=translate(barr+ringthick+mountl2,0,0)*barmount

-- add letters (40mm high, 10mm deep). Manually placed.
j=load('../letters/letter_j.stl')
e=load('../letters/letter_e.stl')
logo=scale(0.3)*mirror(v(1,0,0))*rotate(90,0,0)*union(j,translate(15,0,0)*e)
logo=rotate(0,90,0)*logo
logo=translate(31,15,5.5)*logo

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
------------ PART 3 - light holder --------------------
-------------------------------------------------------

-- split it
ymax=ringedgex+10
xmax=2*ringedgex+mountl1+mountl2
-- halfcube extends from (-xmax,-ymax, 0) to (0, 0, height),
-- so represents the bottom (smaller) part of the bracket.
halfcube=translate(xmax/2,-.5*ymax,0)*cube(xmax,ymax,height)

mountbot=intersection(mount,halfcube)
mounttop=difference(mount,halfcube)

-- move for printing
mountbot=translate(2,-6,0)*mountbot

-- emit the two halves
emit(mounttop)
emit(mountbot)
