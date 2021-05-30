

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
----------------------------------------------------


-- MAIN --

s1 = m4(v(0,0,0),v(20,0,0),20,false,false)
emit(s1)