 -- Welcome to IceSL!
d1=6.3
d2=8.3
d3=12.95
t=2.5
l=15

cr=(d3-d1)/5


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
  local ph=d3/2+2
  local p=difference(
  union(
  translate(0,d3/4,0)*cube(d3,ph,l),
  cylinder(d3/2,l)
  ),
  cylinder(d1/2,l)
  )
  p=difference(p,
    translate(0,ph/2,0)*cube(d1,ph,l-t))

  local l2=l-d1-t
  local cl=d3+0.5
  local ctr=translate(-cl/2,d3/2-(d3-d1)/4,l2-cr-0.05)
  local c=ctr*rotate(90,Y)*cylinder(cr,cl)
  p=difference(p,c)
--emit(p)
  return p
end

function pin()
  local p=cylinder(1,1)
end

p=union(
translate(0,0,2*l)*rotate(180,Y)*rodclip(),
rotate(90,Z)*wheelclip())

emit(rotate(90,X)*p)



