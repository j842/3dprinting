-- stl from https://3dp.rocks/lithophane/
-- Convert image to b&w before uploading, and crop to be square.
-- 
-- Settings
--    Model
--        Max Size         100
--        Thickness        3.5
--        Border           2
--        Thinnest Layer   0.5
--    Image
--        Postive Image (!)

l=load(Path..'IMG_6576.jpegW100H100T3V4B2A0C0NS.stl')

l=union(l,
difference(cube(100,100,3.5),
cube(96,96,3.5)))

l=rotate(90,0,0)*l

emit(l)
