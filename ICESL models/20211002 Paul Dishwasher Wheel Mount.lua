-- Dishwasher replacement part for Paul.
d1=6.3
d2=8.3
d3=12.95
t=2.5
l=15.5
ph=d3/2

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
  local o=difference(
    union(
      cylinder(10/2,2.5),
      cylinder(d2/2,10.3+t+t)
    ),
    cylinder(d1/2,10.3+t+t)
  )
  o=difference(o,cube(10,3,6))
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
  sm=difference(sm,
    translate(0,kl1/2,h-gap)*
    cube((kw+ke)/2,kl1,gap))
  sm=rotate(90,X)*sm
  sm=translate(-kw,0,0)*sm
  return sm
end

function getcube(obj,kw,kl,h)
  local bb=bbox(obj)
  local c=ccube(bb:extent())
--  local c=ccube(kw,h,kl)
  c=translate(bb:center())*c
  return c
end  

h=(d3-d1)/2
kw=(d3-d1)/2
sm=springmechanism(kw,kw/3,l-d1-t,l-t,h)
sm=translate(d3/2,d3/2,0)*sm
-- this translate fixes some rounding error :/
smb=translate(0,.2,0)*getcube(sm,kw,l,h)
sm=union(sm,mirror(X)*sm)
smb=union(smb,mirror(X)*smb)
rc=rodclip()
rc=difference(rc,smb)
rc=union(rc,sm)

--emit(rc)

p=union(
translate(0,0,2*l)*rotate(180,Y)*rc,
rotate(90,Z)*wheelclip())

emit(rotate(90,X)*p)



