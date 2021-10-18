cyld=25
cyll=30
cylt=2

hose=difference(
  cylinder(cyld/2+cylt,cyll),
  cylinder(cyld/2,cyll)
)

asteps=10

contours={}
for c=1,10 do
  cc={}
  for a=1,asteps do
    ar=a*180/asteps
    table.insert(cc,
      v(10*math.sin(ar),10*math.cos(ar),c))
  end

--   cc={}
--   table.insert(cc,v(0,0,c))
--   table.insert(cc,v(10,0,c))
--   table.insert(cc,v(10,10,c))
--   table.insert(cc,v(10*math.cos(c),10,c))
-- --  table.insert(contours,{v(1,1,c),v(1,0,c),v(0,1,c)})
--  contours[c]=cc
  table.insert(contours,cc)
end
    

se = sections_extrude(contours)
emit(se)

-- se=rotate_extrude(
--   {v(0,0,0),v(0,5,3),v(0,5,5),v(0,2,5),v(0,0,0)},
--   100)

-- emit(se)


-- radius = v(10,0,0)
-- triangle = { radius + v(1,0,0), radius + v(0,1,0), radius + v(-1,0,0) }
-- emit( rotate_extrude( triangle, 100 ) )


--waterrr

 -- Welcome to IceSL!
--emit(hose)