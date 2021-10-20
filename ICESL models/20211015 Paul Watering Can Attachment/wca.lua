cyld=25
cyll=30
cylt=2

hose=difference(
  cylinder(cyld/2+cylt,cyll),
  cylinder(cyld/2,cyll)
)

asteps=20
pi=3.141592654

contours={}
for c=1,10 do
  contours[c]={}
  for a=1,asteps do
    ar=a*2*pi/asteps
    contours[c][a]=
      v(20*math.sin(ar),(c+5)*math.cos(ar),c)
  end
--  emit(translate(c,0,0)*linear_extrude(v(0,0,1), contours[c]))
end
    

--se = translate(5,0,0)*sections_extrude(contours)
--emit(se)


--emit(hose)


shape = implicit_distance_field(v(-2,-2,0), v(2,2,8),
[[
float distance(vec3 p) {
	return 0.01 * ((pow(sqrt(p.x*p.x + p.y*p.y) - 3, 3) + p.z*p.z - 1) + noise(p));
}
]])
emit(scale(5) * shape)
