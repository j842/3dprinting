-- tl=590
tl=30

-- thickness of plastic
thickness=3

-- strait piece at bottom
w0=25

-- knob thing
x1=9
w1=1.6
w1b=2.6
w1w=w1b-w1
h1=6
h1b=2.6

-- angled piece
theta=45
l2=45
h2=l2*math.sin(theta)
w2=l2*math.cos(theta)

-- vertical piece at end
l3=10

knobpts={
  v(x1    ,thickness),
  v(x1    ,thickness+h1),
  v(x1+w1 ,thickness+h1),
  v(x1+w1b,thickness+h1-w1w),
  v(x1+w1b,thickness+h1-2*w1w),
  v(x1+w1 ,thickness+h1-2*w1w),
  v(x1+w1 ,thickness)
}

basepts={
  v( 0,0 ),
  v( 0,thickness ),
  v( w0,thickness ),
  v( w0+w2, thickness+h2 ),
  v( w0+w2, thickness+h2+l3 ),
  v( w0+w2+thickness, thickness+h2+l3),
  v( w0+w2+thickness, thickness+h2),
  v( w0+thickness/2,0)
}

base = linear_extrude(v(0,0,tl),basepts)
base = union(base, mirror(v(1,0,0))*base)

knob = linear_extrude(v(0,0,tl),knobpts)
knob = union(knob, mirror(v(1,0,0))*knob)


s = union({
  base,
  knob
})


emit(s)