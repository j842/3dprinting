local jtags = {}


-------------------------------------------------------
-------------------- Functions ------------------------
-------------------------------------------------------

function jtags.gettagsize()
   return v(120,3.5,25)
end

function jtags.gettagborder()
  return 2
end

-------------------------------------------------------
function jtags.nametag(text,image)

--text='Griff'
--image='griffbw.jpegW24H25T3V4B2A0C0NS.stl'

local tsize=jtags.gettagsize()
local w=tsize.x
local t=tsize.y
local h=tsize.z
local e=jtags.gettagborder()
local g=3

-- scale an object to a desired size.
function scaleto(obj,st)
local bb = bbox(obj):extent()
local so = v(st.x/bb.x, st.y/bb.y, st.z/bb.z)
return scale(so)
end

-- load the person's image (lithophane).
local lithopane=load_centered(Path..image)
-- can scale if too big, 
-- but assume lithphane is (25,25,3.5)
--lithopane=scaleto(lithopane,v(h,h,t))*lithopane

-- in case it's slightly smaller 
-- (e.g. 19mm wide), fill in the gaps.
local lithobox=bbox(lithopane):extent()
lithopane=difference(ccube(h,h,t),difference(ccube(lithobox),lithopane))
lithopane=rotate(0,180,0)*lithopane
local l=translate(w/2-h/2,0,t/2)*lithopane

local f=font(Path..'/../ttf/StardosStencil-Bold.ttf')
local letters=rotate(0,180,0)*f:str(text,1)

-- scale text to h-2*g height.
local thinness=0.5
local lscale=(h-2*g)/bbox(letters):extent().y
letters=scale(lscale,lscale,t-thinness)*letters
letters=jshapes.xycenter(letters)

-- handle letters too wide to fit nametag
local maxx=w-h-2*g
if (bbox(letters):extent().x>maxx) then
  local ls=maxx/bbox(letters):extent().x
  letters=scale(ls,1,1)*letters
  letters=translate(0,0,0)*letters
else
  letters=translate(-h/3,0,0)*letters
end

-- center if possible, otherwise shift right
local lettersbox=bbox(letters):extent()
if (lettersbox.x>w-2*h) then
  local deltax=(w-lettersbox.x)/2-h-g
  letters=translate(deltax,0,0)*letters
end

-- inverse of letters
local tag=translate(-h/2,0,0)*cube(w-h,h,t)
tag=difference(tag,letters)

-- add a border
local border=difference(cube(w,h,t),cube(w-e,h-e,t))

tag=union({tag,border,l})

-- flip up for printing
tag=rotate(90,0,0)*tag
tag=jshapes.xycenter(tag)

tag=union(tag,rotate(180,X)*magnet('t1'))

return tag
end
-------------------------------------------------------


return jtags
  