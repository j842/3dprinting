-- Dishwasher replacement part for Paul.

set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',true)
set_setting_value('support_overhang_overlap_fraction',0.4)
set_setting_value('support_algorithm','Wings')
set_setting_value('infill_percentage_0',100)

-----------------------
d1=6.3
d2=8.5 -- original part measured at 8.3 (as in MkI) , but has a bit much play.
d3=12.95
t=2.5
l=15.5
ph=d3/2
wl=10.3+t+t

--cr=(d3-d1)/5

-- center in x and y, and place on z=0 surface.
function xycenter(objtocenter)
  local v=bbox(objtocenter):center()
  objtocenter=translate(-v.x,-v.y,-v.z)*objtocenter
  local h=bbox(objtocenter):min_corner().z
  return translate(0,0,-h)*objtocenter
end

--- cube with 45o "rounded" corners.
function cornercube(x,y,z)
  local c=cube(x,y,z)
  local d=translate(0,0,0)*rotate(45,Z)*c
  c=intersection(c,d)
  return c
end


-- wheel clip/mount
function wheelclip()
  local ridged=10.2  -- was 10.0 in mkI
  ch=ridged/2-d2/2
  cht=2.5
  local o=difference(
    union({
      cylinder(ridged/2,cht-ch), 
      translate(0,0,cht-ch)*cone(ridged/2,d2/2,ch),
      cylinder(d2/2,wl)}
    ),
    cylinder(d1/2,wl)
  )
-- was 10,3,6 in mkI
  o=difference(o,cube(ridged,0.5+ridged-d2,6)) 
  return o
end

-- bit rod clips in
function rodclip()
  local p=
  union(
    translate(0,d3/4,0)*cube(d3,ph,l),
    cornercube(d3,d3,l)
--    cylinder(d3/2,l)
  )

  p=difference(p,
    translate(0,ph/2,0)*cube(d1,ph,l-t))

  round=translate(0,ph/2,l-t-d1/2)*difference(cube(d1,ph,d1/2),
      translate(0,d1/2+0.5,0)*rotate(90,X)*cylinder(d1/2,d1+1))

--  r2=translate(0,0,l-t-d1/2)*rotate(90,X)*cylinder(d1/2,d1+1)
--  emit(r2)

  p=union(p,round)
  p=difference(p,cylinder(d1/2,l))

  return p
end

function springmechanism(kw,ke,kl1,kl,h)
  local gap=0.8
  local maxh=kl1+ke-gap

  local springer={ 
      v{ke/2,0,0},
      v{-ke,kl1-gap,0}, 
      v{0,maxh,0},
      v{3*ke/2,1.8*ke,0},
      v{kw/2,kl1,0}, 
      v{0,kl1+kw/2,0},
      v{0,kl1+kw/2,0},
      v{kw,kl1+kw/2,0},
      v{kw,0,0}}
  local sm=linear_extrude(v(0,0,h),springer)

  -- remove a piece so clip can move
  sm=difference(sm,
    translate(5*ke/4-ke,maxh/2,h-gap)*
    cube(5*ke/2,maxh,gap))

  sm=rotate(90,X)*sm
  sm=translate(-kw,0,0)*sm
  return sm
end

function getcube(obj)
  local bb=bbox(obj)
  local c=ccube(bb:extent())
  c=translate(bb:center())*c
  return c
end  

function fullrodclip()
  local h=(d3-d1)/2+1
  local kw=(d3-d1)/2
  -- make clips a little longer (+0.5mm) from MKI.
  local sm=springmechanism(kw,1.3,l-d1-t+0.5,l-t,h)

  sm=translate(d3/2,d3/2,0)*sm
  -- this translate fixes a gap, which 
  -- maybe be incorrect code (or rounding)
  smb=translate(0,.2,0)*getcube(sm,kw,l,h)
  
  sm=union(sm,mirror(X)*sm)
  smb=union(smb,mirror(X)*smb)

  return union(sm,difference(rodclip(),smb))
end

rc = fullrodclip()

p=union(
translate(0,0,l+wl-t)*rotate(180,Y)*rc,
rotate(90,Z)*wheelclip())

p=xycenter(rotate(90,X)*p)

--emit(cornercube(d3,d3,l))

numthings=3
for i=1,numthings,1 do
  emit(translate(d3*1.25*i,0,0)*p)
end





