-- Holder for LED light for Prusa i3 
-- LED is Arlec UC473, wide angle corned led bar light
-- https://www.bunnings.co.nz/arlec-7w-aluminium-wide-angle-corner-led-bar-light_p0099381

iholder=load_centered_on_plate('Tantalus_LED_Light_Strip_Bracket_v2.stl')
remove=union(
translate(30,0,0)*cube(160,90,8),
translate(0,-80,0)*cube(180,90,8)
)
iholder=difference(iholder,remove)

bx=bbox(iholder):extent()
x=bx.x
y=bx.y
z=bx.z

rad=22

voff=v(73,50,0)

c=translate(0,-3,0)*cylinder(rad,z)
iholder=difference(iholder,translate(voff)*c)


lr=36.5/2
dy=-3
lighthole=translate(0,dy,0)*intersection(cylinder(lr,8),translate(0,-lr/2,0)*cube(100,lr,z))

lighthole=union({lighthole,
translate(0,4+dy,0)*cube(14,18,z),
translate(-6,dy+1,0)*rotate(0,0,45)*cube(16,18,z),
translate(0,dy-1,0)*cube(36.4,5,z),
translate(0,-21,0)*cube(lr*2,10,z)
})
lighthole=union(lighthole,mirror(v(1,0,0))*lighthole)

--emit(lighthole)

c=difference(c,
lighthole)
c=translate(voff)*c


holder=union(iholder,c)

holder=difference(holder,translate(-50,0,0)*cube(200,200,z))
--holder=union(holder,translate(5,0,0)*rotate(0,0,180)*holder)

emit(holder)



