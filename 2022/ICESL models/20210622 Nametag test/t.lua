  
width = ui_scalar('Width (mm)', 28, 20, 40)
thickness = ui_scalar('Thickness (mm)', 1, 0.3, 2)

f = font(Path..'../ttf/StardosStencil-Bold.ttf')
text = f:str('IceSL', 1)

c1 = v(0,0,0)
c2 = v(width,0,0)
c3 = v(width/2,(math.sqrt(3)/2) * -width,0)

cl1 = translate(c1) * cylinder(width,thickness)
cl2 = translate(c2) * cylinder(width,thickness)
cl3 = translate(c3) * cylinder(width,thickness)

tbox = bbox(text)
factor = (width / 1.5) / tbox:extent().x

shape = to_voxel_solid(I{cl1,cl2,cl3}, 0.1)
smooth_voxels(shape, 10)

emit(shape)
emit(
 translate(
   math.abs(factor * tbox:extent().x -width)/2,
  -factor * tbox:extent().y,
   thickness) *
 scale(
   factor,
   factor,
  (thickness / 2) / tbox:extent().z) *
text,0)
