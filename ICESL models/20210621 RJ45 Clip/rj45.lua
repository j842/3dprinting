 -- RJ45 Clip
clip=load_centered_on_plate('rj45-clip_04.9.nf.stl')
bx=bbox(clip):extent()
x=bx.x
y=bx.y
z=bx.z

clip=translate(x/2+2,y/2+2,0)*clip
clip=union({
  clip,
  mirror(v(1,0,0))*clip
})
clip=union({
  clip,
  mirror(v(0,1,0))*clip
})


emit(clip)



