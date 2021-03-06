-- Dishwasher replacement part for Paul.

set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',true)
set_setting_value('support_overhang_overlap_fraction',0.3)
set_setting_value('support_algorithm','Bridges')
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

-- wheel clip/mount
function wheelclip()
  local ridged=11 -- was 10 in MkI.
  local o=difference(
    union(
      cylinder(ridged/2,2.5), 
      cylinder(d2/2,wl)
    ),
    cylinder(d1/2,wl)
  )
-- was 10,3,6 in mkI
  o=difference(o,cube(ridged,2.5,6)) -- 2.5 >= 11-8.5 
  return o
end

-- bit rod clips in
function rodclip()
  local p=difference(
  union(
  translate(0,d3/4,0)*cube(d3,ph,l),
  cylinder(d3/2,l)
  ),
  cylinder(d1/2,l)
  )
  p=difference(p,
    translate(0,ph/2,0)*cube(d1,ph,l-t))

  return p
end

function springmechanism(kw,ke,kl1,kl,h)
  local gap=0.5

  local springer={ 
      v{ke/2,0,0},
      v{-ke,kl1-gap,0}, 
      v{0,kl1-gap,0},
      v{3*ke/2,ke,0},
      v{kw/2,kl1,0}, 
      v{0,kl1,0},
      v{0,kl,0},
      v{kw,kl,0},
      v{kw,0,0}}
  local sm=linear_extrude(v(0,0,h),springer)

  -- remove a piece so clip can move
  sm=difference(sm,
    translate(5*ke/4-ke,kl1/2,h-gap)*
    cube(5*ke/2,kl1,gap))

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
  local h=(d3-d1)/2
  local kw=(d3-d1)/2
  -- make clips a little longer (+0.5mm) from MKI.
  local sm=springmechanism(kw,1.2,l-d1-t+0.5,l-t,h)

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

p=rotate(90,X)*p

emit(p)

-- numthings=6
-- for i=1,numthings,1 do
--   emit(translate(d3*1.5*i,0,0)*p)
-- end





