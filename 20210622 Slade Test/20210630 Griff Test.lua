-- Griff Namebadge
-- https://3dp.rocks/lithophane/

package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

h=25
w=120
t=3.5
g=3
e=2

-- scale an object to a desired size.
function scaleto(obj,st)
local bb = bbox(obj):extent()
local so = v(st.x/bb.x, st.y/bb.y, st.z/bb.z)
return scale(so)
end


-- load the person's image (lithophane).
lithopane=load_centered(Path..'griffbw.jpegW24H25T3V4B2A0C0NS.stl')
-- can scale if too big, 
-- but assume lithphane is (25,25,3.5)
--lithopane=scaleto(lithopane,v(h,h,t))*lithopane

-- in case it's slightly smaller 
-- (e.g. 19mm wide), fill in the gaps.
lithobox=bbox(lithopane):extent()
lithopane=difference(ccube(h,h,t),difference(ccube(lithobox),lithopane))
lithopane=rotate(0,180,0)*lithopane
l=translate(w/2-h/2,0,t/2)*lithopane

f=font(Path..'/../ttf/StardosStencil-Bold.ttf')
letters=rotate(0,180,0)*f:str('Griff',1)

-- scale text to h-2*g height.
thinness=0.4
lscale=(h-2*g)/bbox(letters):extent().y
letters=scale(lscale,lscale,t-thinness)*letters
letters=jshapes.xycenter(letters)
letters=translate(-h/3,0,thinness)*letters

-- handle letters too wide to fit nametag
maxx=w-h-2*g
if (bbox(letters):extent().x>maxx) then
  ls=maxx/bbox(letters):extent().x
  letters=scale(ls,1,1)*letters
end

-- center if possible, otherwise shift right
lettersbox=bbox(letters):extent()
if (lettersbox.x>w-2*h) then
  deltax=(w-lettersbox.x)/2-h-g
  letters=translate(deltax,0,0)*letters
end

-- inverse of letters
tag=translate(-h/2,0,0)*cube(w-h,h,t)
tag=difference(tag,letters)

-- add a border
border=difference(cube(w,h,t),cube(w-e,h-e,t))

tag=union({tag,border})

-- tracmap=load_centered(Path..'Main-TracMap-Logo-GreenBlue-Clear.pngW40H9T3V4B2A0C0NS.stl')
-- tracmap=jshapes.xycenter(tracmap)
-- tbox=bbox(tracmap):extent()
-- tracmap=difference(cube(tbox),tracmap)
-- tracmap=mirror(v(1,0,0))*tracmap
-- tracmap=translate(0,h/2-tbox.y/2,0)*tracmap
-- tag=difference(tag,tracmap)

-- flip up for printing
tag=rotate(90,0,0)*tag

l=rotate(90,0,0)*l

debug=false
if (debug) then
  set_brush_color (1,1,1,1)
  emit(tag,1)
  set_brush_color (2,1,0,1)
  emit(l,2)
else
  emit(union(tag,l))
end