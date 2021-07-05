local jtags2 = {}


-------------------------------------------------------
-------------------- Functions ------------------------
-------------------------------------------------------

function jtags2.gettagsize()
   return v(120,3.5,25)
end

function jtags2.gettagborder()
  return 2
end

-------------------------------------------------------
function jtags2.nametag(text,image)

--text='Griff'
--image='griffbw.jpegW24H25T3V4B2A0C0NS.stl'

local tsize=jtags2.gettagsize()
local w=tsize.x
local t=tsize.y
local h=tsize.z
local e=jtags2.gettagborder()
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

local f=font(Path..'/../ttf/OtomanopeeOne-Regular.ttf')
--local f=font(Path..'/../ttf/Lato-Black.ttf')
local letters=rotate(0,180,0)*f:str(text,0.5)

-- scale text to h-2*g height.
local thinness=0.5
local lscale=(0.8*(h-2*g))/bbox(letters):extent().y
letters=scale(lscale,lscale,t-thinness)*letters
letters=jshapes.xycenter(letters)

-- handle letters too wide to fit nametag
local maxx=w-h-2*g
if (bbox(letters):extent().x>maxx) then
  local ls=maxx/bbox(letters):extent().x
  letters=scale(ls,1,1)*letters
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

function jtags2.flatyrect(offset,x,z)
    return {
    translate(offset)*v{-x/2,0,0},
    translate(offset)*v{-x/2,0,z},
    translate(offset)*v{x/2,0,z},
    translate(offset)*v{x/2,0,0}
    }
  end

  function jtags2.holder()
  local g=jtags2.gettagborder()
  local feather=0.5
  local ts=jtags2.gettagsize()+v(feather,feather,0)
  local hs=v(ts.x+2*g,25,ts.z+g)
  local h=cube(hs)

  -- remove slot for tag
  h=difference(h,translate(0,hs.y/2-ts.y/2-g,hs.z-ts.z)*cube(ts))
  -- remove material in front of slot so you can see tag
  h=difference(h,translate(0,hs.y/2-ts.y/2,hs.z-ts.z+g)*cube(ts.x-2*g,ts.y,ts.z-g))
  -- make hole for led cable
  h=difference(h,translate(-hs.x/2+16,-hs.y/2+g,2*g)*cube(10,2*g,3))
 
  -- tapered ridge for tag to rest against (minimising plastic without needing supports)
  s1=jtags2.flatyrect(v(0,-(hs.y-ts.y)/2,g),hs.x-2*g,hs.z-2*g)
  s2=jtags2.flatyrect(v(0,(hs.y-ts.y)/2,2*g),hs.x-4*g,hs.z-3*g)
  local se= sections_extrude({
    s1,
    s2
  })
  h=difference(h,se) 
-- h=se

  -- remove material behind slot so light can get to it
  --h=difference(h,translate(0,-g/2,2*g)*cube(hs.x-4*g,hs.y-ts.y-g,hs.z-3*g))
  -- save plastic by cutting out non-visible inside
  --h=difference(h,translate(0,-3*g/2,g)*cube(hs.x-2*g,hs.y-ts.y-3*g,hs.z-2*g))

  -- add TracMap text to top
  local stickout=g
  tracmap=jshapes.xycenter(mirror(v(1,0,0))*rotate(180,X)*load(Path..'_tracmap black.stl'))
  tbox=bbox(tracmap):extent()
  tracmap=difference(scale(0.95,0.95,g/tbox.z)*cube(tbox),tracmap)
  tracmap=jshapes.xycenter(tracmap)
  tbox=bbox(tracmap):extent()
  tracmap=translate(0,-hs.y/2+tbox.y/2+g,hs.z-tbox.z+g)*tracmap
  h=union(h,tracmap)


  h=union(h,translate(0,hs.y/2-g-ts.y/2,g)*magnet('h1'))
  return h
end
-------------------------------------------------------


return jtags2
  