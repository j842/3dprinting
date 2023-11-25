-- diffuser for microscope objective

set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',false)
set_setting_value('infill_percentage_0',15)


package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

-- width of microsccope objective lens
objectivew=24


gap=0.1
innerr=objectivew/2+gap
shroudw=58
happythick=3
viewthick=1
totalh=65


-- create full height block from xl to xr, with thickness ythick, and bolts at xboltpos.
function addboltedtab(sring, xl,xr,xboltpos,ythick,height,boltheight)
  -- provide 1mm extension for 15mm bolt in case fit is tight and gap needed.
  local bolts=15-1

  sring=union(sring, translate(xl+0.5*(xr-xl),0,0)*cube(xr-xl,ythick,height))

  local vec=v(xboltpos,ythick/2,boltheight)
  local b1=jshapes.m4rn(v(vec.x,vec.y,vec.z),v(vec.x,-vec.y,vec.z),bolts)
  vec.z=0.75*height
--  local b2=jshapes.m4rn(v(vec.x,vec.y,vec.z),v(vec.x,-vec.y,vec.z),bolts)

  sring=difference(sring,b1)
--  sring=difference(sring,b2)

  return sring
end


r0=innerr+happythick
r1=r0+4
r2=r1
h0=14
h1=10
h2=10

a=cylinder(r0,h0)
a=union(a,
translate(0,0,h0)*
difference(
cone(r0,r1,h1),
cone(r0-viewthick,r1-viewthick,h1)
)
)

a=union(a,
 translate(0,0,h1+h0)*
 difference(
 cylinder(r1,h2),
 cylinder(r1-viewthick,h2)
 )
 )

base=union(
cylinder(shroudw/2,happythick),
cylinder(r0+happythick,2*happythick)
)
a=union(a,base)

xr=r1-6
m4len=10
a=addboltedtab(a,xr,xr+m4len,xr+m4len/2,20,h0,2*h0/3)
a=addboltedtab(a,-xr-m4len,-xr,-xr-m4len/2,20,h0,2*h0/3)


b=cylinder(innerr,totalh)
a=difference(a,b)

--a=translate(0,0,happythick)*a
--emit(a)

-- split it
xmax=shroudw
ymax=shroudw
height=totalh
halfcube=translate(0,-ymax,0)*cube(xmax,2*ymax,height)
--emit(halfcube)
abot=intersection(a,halfcube)
atop=difference(a,halfcube)

abot=translate(0,-5,0)*abot

emit(atop)
emit(abot)


---------------------------------------------

-- topr=60
-- bracketw=50

-- top=difference(
-- cylinder(topr,happythick),
-- union(
-- {
-- cylinder(innerr,totalh),
-- translate(topr/2,0,0)*ccube(topr,innerr*2,totalh),
-- translate(topr/2+shroudw/2,0,0)*ccube(topr,bracketw,totalh)
-- }))

-- top=union(top,
-- difference(cylinder(topr,totalh),cylinder(topr-viewthick,totalh))
-- )

-- magich=30
-- top=difference({top,
-- translate(topr,0,magich)*cone(bracketw/2,0,magich+2),
-- translate(topr,0,0)*cube(topr,bracketw,magich+0.1)}
-- )

-- emit(top)



--emit(cylinder(24/2,30))
