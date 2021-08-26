package.path = package.path .. ";../common/?.lua"
jshapes=require("jshapes")

debug=false


-- print settings
set_setting_value('use_different_thickness_first_layer',true)
set_setting_value('z_layer_height_first_layer_mm',0.3)
set_setting_value('z_layer_height_mm',0.2)
set_setting_value('gen_supports',true)
set_setting_value('add_brim',true)

set_brush_color (0,.1,.5,.5)
set_setting_value('infill_percentage_0',5)
set_setting_value('cover_thickness_mm_0',1.5)

set_brush_color(1,0,1,0)
set_setting_value('infill_percentage_1',20)
set_setting_value('cover_thickness_mm_0',1.2)

----------------------------------------------

maxtailw=2

function scaleinplace(obj,sf)
  local bb=bbox(obj):center()
  return translate(bb)*
            scale(sf)*
            translate(-bb)*
            obj
end

function pikachu()
  local sbox=load_centered_on_plate('Pikachu.stl')
  local sboxsize=50
  sbox=scale(sboxsize)*sbox
  local ss=bbox(sbox):extent()

  local insert1=
    translate(0,6.25,27)*cube(maxtailw,2,10)
  local insert2=
    translate(0,-19,23)*cube(maxtailw,2.5,10)

  local box=difference(
    translate(0,0,25)*cube(ss.x+1,ss.y+1,35),
    union({
    translate(0,6.25,18.9)*cube(1,3,10),
    translate(0,6,18)*cube(2,8,10)
  }
    )
  )
  local body=intersection(sbox,box)
  body=difference({body,
      scaleinplace(insert1,1.2),
      scaleinplace(insert2,1.2)
})

  local eye=translate(5.5,17,50)*
    rotate(-35,X)*rotate(19,Y)*
    difference(cylinder(2.5,1),
    translate(-0.3,0.7,0)*cylinder(1.2,.3))

  body=difference({
      body,eye,mirror(X)*eye
      })

  local mt=4
  local mouth =scale(0.8,1.2,1)* 
      intersection({cube(15,15,mt),
        difference(cube(15,15,mt),
          translate(-4,10,0)*cylinder(9,mt)),
        translate(-3,1,0)*cylinder(5,mt)})
  body=difference(body,
          translate(2.5,7,54)*rotate(35,X)*mouth)


  local tail=difference(sbox,box)

  tail=scale(5,1,1)*tail
  tail=intersection(cube(maxtailw,100,100),tail)
  tail=union({tail,insert1,insert2})

  body=scale(1.6)*body
  tail=scale(1.6)*tail

  return {body,tail}
end

p=pikachu()

if (debug) then
  body=p[1]
  tail=p[2]
else
  body=jshapes.xycenter(p[1])
  tail=translate(70,0,0)*jshapes.xycenter(
     rotate(90,Y)*p[2]
   )
end

emit(body,0)
emit(tail,1)