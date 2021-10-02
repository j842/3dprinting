 -- Welcome to IceSL!
d1=6.3
d2=8.3
d3=12.95
t=2.5

-- wheel clip/mount
o=difference(
  union(
    cylinder(10/2,2.5),
    cylinder(d2/2,10.3+t+t)
  ),
  cylinder(d1/2,10.3+t+t)
)
o=difference(o,cube(10,3,6))

-- bit rod clips in
l=15
ph=d3/2+2
p=difference(
union(
translate(0,d3/4,0)*cube(d3,ph,l),
cylinder(d3/2,l)
),
cylinder(d1/2,l)
)
p=difference(p,
  translate(0,ph/2,0)*cube(d1,ph,l-t))

l2=l-d1-t
--p=difference(p,
--translate(0,d3/2-(d3-d1)/4,0)*cube(d3,(d3-d1)/2,l2))

cr=(d3-d1)/5
cl=d3+0.5
ctr=translate(-cl/2,d3/2-(d3-d1)/4,l2-cr-0.05)
c=ctr*rotate(90,Y)*cylinder(cr,cl)
p=difference(p,c)

--emit(p)

p=union(
translate(0,0,2*l)*rotate(180,Y)*p,
rotate(90,Z)*o)

emit(rotate(90,X)*p)



