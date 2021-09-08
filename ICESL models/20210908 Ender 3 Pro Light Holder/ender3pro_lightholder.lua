-- Holder for LED light for Ender 3 Pro
-- LED is Arlec UC473, wide angle corned led bar light
-- https://www.bunnings.co.nz/arlec-7w-aluminium-wide-angle-corner-led-bar-light_p0099381




---------------------------------------

-- print settings
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',false)
set_setting_value('add_brim',true)

-- planter brush
set_brush_color (0,.1,.3,.5)
set_setting_value('infill_percentage_0',20)

----------------------------------------------


l=80


iholder=rotate(90,Z)*load_centered_on_plate('insert.stl')
z=bbox(iholder):extent().z
iholder=scale(1,1,2)*iholder
iholder=translate(
  bbox(iholder):extent().x/2-1,-32,0)*iholder
iholder=rotate(0,0,180)*iholder
iholder=union(iholder,
  translate(l/2,32,0)*
cube(l,12,z))

for cx=10,l-30,10 do
  iholder=difference(iholder,
    translate(cx,32,0)*cylinder(2,z))
end

bx=bbox(iholder):extent()
x=bx.x
y=bx.y
z=bx.z/2

rad=22


voff=v(l,20,0)
c=translate(0,-3,0)*cylinder(rad,z)
iholder=difference(iholder,translate(voff)*c)


lr=36/2
dy=-3
lighthole=translate(0,dy,0)*intersection(cylinder(lr,8),translate(0,-lr/2,0)*cube(100,lr,z))

lighthole=union({lighthole,
translate(0,4+dy,0)*cube(14,18,z),
translate(-6,dy+1,0)*rotate(0,0,45)*cube(16,18,z),
translate(0,dy-1,0)*cube(36,5,z),
translate(0,-21,0)*cube(lr*2,10,z)
})
lighthole=union(lighthole,mirror(v(1,0,0))*lighthole)

--emit(lighthole)

c=difference(c,
lighthole)
c=translate(voff)*c


holder=union(iholder,c)

--holder=difference(holder,translate(-50,0,0)*cube(200,200,z))
holder=union(holder,translate(51,40,0)*mirror(X)*holder)

emit(holder)



