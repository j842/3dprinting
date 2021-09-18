 -- Welcome to IceSL!

baser=5
baseh=2.1

pinh=14.6
pinr=0.5*3.6

notchh=1.5
notcho0=1.0
notchr=0.5*2.85


notcho=pinh-notchh-notcho0 -- from bottom of pin to bottom of notch


base=cylinder(baser,baseh)
c=translate(0,0,-0.9*baser)*cone(0,2*baser,2*baser)
base=intersection(base,c)

pin=cylinder(pinr,pinh)
ring=difference(
    cylinder(pinr,notchh),
    cylinder(notchr,notchh)
)
pin=difference(pin,translate(0,0,notcho)*ring)

pincone=translate(0,0,pinh-1.2*pinr)*cone(2*pinr,0,2*pinr)
pincone=intersection(difference(pin,pincone),
  translate(0,0,pinh-pinr)*cylinder(pinr,pinh))
pin=difference(pin,pincone)

oventhing=union({base,pin})


numpins=6
for i=1,numpins,1 do
  emit(translate(baser*3*i,0,0)*oventhing)
end