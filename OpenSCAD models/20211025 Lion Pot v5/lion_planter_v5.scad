// Lion Planter v5.
// Does not need supports.

use <stl/lion2.scad>
use <stl/leaf.scad>


printplanter=true;
printbase=true;

// Scale factor - determines size of planter. 
// 1.0, 1.25, 1.5 and 1.95 all tested.
k=1.25;

epsilon=0.005;
opepsilon=1+epsilon;
vepsilon=epsilon*[1,1,1];
t=2.0+k/2;
embosst=0.6;
w=80;
hh=k*80;
kw=k*w;
rr=kw/6.5;

$fn=100;


// baseshape, with walls adjusted by offset (inwards)
  module baseshape(off) {
    union() {
      translate([off,-(kw-2*off)/2,0])
        cube([kw-2*off,kw-2*off,hh-off]);
        
      translate([-rr+off,-rr+off,0])
        cube([rr+epsilon+off,2*rr-2*off,hh/3-off]);

      translate([-rr,0,0]) 
        cylinder(h=hh/3-off,r=rr-off);
    }
}

// hole for water to go from spout to planter
  module spouthole() {
    shw=0.8*(2*rr-2*t);
    sht=t+1;
    shh=0.05*hh/4;
    intersection()
      {
          union() 
          {
              translate([0,-t/2,t]) cube([shw,sht,shh]);
              translate([0,0,t+shh]) rotate([90,0,0]) cylinder(h=sht,r=shw/2);
          }
          translate([0,-sht/2,t]) cube([shw,sht,hh/3]);
      }
  }

  module cylinderz(a,kfac,aoff) {
      translate([kw/2,0,0]) rotate([0,0,a+aoff]) 
        translate([kfac*k,0,0]) cylinder(h=kw, r=0.8*t);
  }
  
  module permeablebase() {
    // curved holed inside water filter bit
    rr0=kw/4;
    c0=t;
    numholes=15;
    ad=360/numholes;
      
    difference()
      {
        translate([kw/2,0,0]) intersection()
        {
          difference() {
            translate([0,0,c0]) 
                cylinder(h=kw,r1=rr0,r2=kw+rr0);
            translate([0,0,c0-epsilon])
                cylinder(h=kw,r1=rr0-t,r2=kw-t);
            }
            translate([0,0,kw/2]) cube([kw,kw,hh],true);
        }
        
        for (a=[1:numholes]) {
            cylinderz(a*ad,19,0.5*ad);
            cylinderz(a*ad,24,0);
            cylinderz(a*ad,28,0.5*ad);
            cylinderz(a*ad,32,0);
        }
    }
}

module frontleaves()
{
    translate([-epsilon,5,70*k]) scale([4,1,1]) rotate([90,0,-90]) leaf();

    mirror([0,1,0]) translate([-epsilon,5,70*k]) scale([4,1,1])     rotate([90,0,-90]) leaf();
}

module backleaves()
{
    scale([1,0.6,0.6]) mirror([1,0,0]) translate([-kw,0,0]) union()
    {
    translate([-epsilon,5,70*k]) scale([4,1,1]) rotate([90,0,-90]) leaf();

    mirror([0,1,0]) translate([-epsilon,5,70*k]) scale([4,1,1])     rotate([90,0,-90]) leaf();
    }
}

module closeleaves()
{
    union()
    {
        
        translate([-epsilon,-5,70*k]) scale([4,1,1]) rotate([90,0,-90]) leaf();

        mirror([0,1,0]) translate([-epsilon,-5,70*k]) scale([4,1,1])     rotate([90,0,-90]) leaf();
    }
}

module sideleaves()
{
    translate([kw/2,0,0]) rotate([0,0,90]) translate([-kw/2,0,0])
    closeleaves();
    
    translate([kw/2,0,0]) rotate([0,0,-90]) translate([-kw/2,0,0]) closeleaves();
}

union() 
{
    difference() 
    {
        baseshape(0);
        translate([0,0,t+epsilon]) baseshape(t);
        spouthole();
    }
    permeablebase();
}

translate([t-epsilon,0,55*k]) rotate([90,0,-90]) scale(0.25*k) lion();

frontleaves();
backleaves();
sideleaves();




