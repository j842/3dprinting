-- diffuser for microscope objective
-- clamped on with 20mm m4 bolts.

set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',false)
set_setting_value('add_brim',false)
set_setting_value('infill_percentage_0',15)


package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

-- width of microsccope objective lens
objectivew=25

-- other parameters
gap=0.1
innerr=objectivew/2+gap
shroudw=49.8
happythick=2.4
viewthick=1
totalh=65

-- round the top half of the cube nicely...
function rcube(dx,dy,dz)
  return intersection(
    cube(dx,dy,dz),
    union(
    translate(0,dy/2,dz/2+(dz-dx)/2)*rotate(90,0,0)*cylinder(dx/2,dy),
    cube(dx,dy,dz/2+(dz-dx)/2)
)
)
end

-- create full height block from xl to xr, with thickness ythick, and bolts at xboltpos.
function addboltedtab(sring, xl,xr,xboltpos,ythick,height,boltheight,boltlength)

local housing=translate(xl+0.5*(xr-xl),0,0)*
  rcube(xr-xl,ythick,height)

  local vec=v(xboltpos,ythick/2,boltheight)
  local b1=jshapes.m4rn(v(vec.x,vec.y,vec.z),v(vec.x,-vec.y,vec.z),boltlength-0.2)

  sring=difference(union(sring,housing),b1)

  return sring
end

-- tiny light diffuser
r0=innerr+happythick
r1=r0+4
h0=14
h1=8
h2=12

a=union(
{
-- base part (two discs)
  cylinder(shroudw/2,happythick),
  cylinder(r0+happythick,2*happythick),

-- stem - clamps the objective
  cylinder(r0,h0),

-- conical diffuser part
  translate(0,0,h0)*difference(
  cone(r0,r1,h1),
  cone(innerr,r1-viewthick,h1)
  ),

-- straight (top) diffuser part
  translate(0,0,h1+h0)*
  difference( cylinder(r1,h2), cylinder(r1-viewthick,h2) )
}
)

-- bolt tabs
xr=r1-6
xw=9.8
m4len=20
a=addboltedtab(a,xr,xr+xw,xr+xw/2,m4len,h0,0.6*h0,m4len)
a=addboltedtab(a,-xr-xw,-xr,-xr-xw/2,m4len,h0,0.6*h0,m4len)

-- make sure nothing is in the way of where the objective goes!
b=cylinder(innerr,totalh)
a=difference(a,b)

-- split it
xmax=shroudw
ymax=shroudw
height=totalh
halfcube=translate(0,-ymax,0)*cube(xmax,2*ymax,height)
abot=intersection(a,halfcube)
atop=difference(a,halfcube)

-- render either together or apart (for printing) as needed.
clamp_apart=union(translate(0,-5,0)*abot,atop)
clamp_together=rotate(0,0,90)*translate(0,0,happythick)*union(abot,atop)


-------------------------------------------

topr=60
bracketw=math.max(50,shroudw)+0.2 -- 50 is bracket width, but shroud needs to go in too

lightshade=difference(
cylinder(topr,happythick),
union(
{
cylinder(innerr,totalh),
translate(topr/2,0,0)*ccube(topr,innerr*2,totalh),
translate(topr/2+shroudw/2,0,0)*ccube(topr,bracketw,totalh)
}))

lightshade=union(lightshade,
difference(cylinder(topr,totalh),cylinder(topr-viewthick,totalh))
)

-- magich=30
-- lightshade=difference({lightshade,
-- translate(topr,0,magich)*cone(bracketw/2,0,magich+2),
-- translate(topr,0,0)*cube(topr,bracketw,magich+0.1)}
-- )

lightshade=difference({lightshade,
  translate(topr,0,0)*cube(topr,bracketw,totalh)})


----------------------------------------------------

emit(clamp_apart)

--emit(clamp_together)
--emit(lightshade)

