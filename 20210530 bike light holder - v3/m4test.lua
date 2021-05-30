
-------------------------------------------------------
------------ Functions             --------------------
-------------------------------------------------------

----------------------------------------------------
----------------------------------------------------

-- rotate v1 to v2
function rotvec(v1,v2)
  local rvec=cross(v1,v2)
  -- if v1 and v2 parallel, get any perpendicular vector.
  if (length(rvec)==0) then 
    rvec=cross(v1,normalize(v(1,2,5)))
  end
  return rvec
end

-- rotate v1 to v2
function rotangle(v1,v2)
  local angle = math.acos( dot(v1,v2) )*180/3.141592654 
  local vc = rotvec(v1,v2)
  local vrot=rotate(angle,vc)*v1
  local vrot2=rotate(angle+180,vc)*v1
  if (length(vrot-v2)>length(vrot2-v2)) then
    angle=angle+180
  end
  return angle
end

-- get rotation matrix to rotate v1 to v2
function rotationmatrix(v1,v2)
   local v1n=normalize(v1)
   local v2n=normalize(v2)
   local rv = rotvec(v1n,v2n)
   local ra = rotangle(v1n,v2n)

   return rotate(ra,rv)
end

function nutshape(ndepth)
-- nyloc nuts were very tight at 4mm radius, cracking the plastic, so add a little (+0.15mm)
local r=4.15
local rx=r/2
local ry=0.866025*r
local nut={ v{r,0,0},v{rx,ry,0},v{-rx,ry,0},v{-r,0,0},v{-rx,-ry,0},v{rx,-ry,0}}
local nuthole=linear_extrude(v(0,0,ndepth),nut)
return nuthole
end


-- create m4 recess. nyloc=true for nyloc nut.
-- head at vstart, nut at vend
function m4(vstart,vend,boltlength,isnyloc)
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
if (isnyloc) then ndepth=4.5 end
local nuthole=nutshape(ndepth)
nuthole=translate(0,0,holelength-ndepth)*nuthole

local assembly=union(b,nuthole)

-- vstart at 0,0,0 currently
avec=v(0,0,1)
assembly=rotationmatrix(avec,vend-vstart)*assembly

assembly=translate(vstart)*assembly
return assembly
end
----------------------------------------------------


-- MAIN --

s1 = m4(v(0,0,0),v(0,0,25),20,false)
emit(s1)