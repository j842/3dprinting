// Lion Planter v5.
// Does not need supports.

use <stl/lion.scad>
use <stl/leaf.scad>


printplanter=true;
printbase=true;

// Scale factor - determines size of planter. 
// 1.0, 1.25, 1.5 and 1.95 all tested.
k=1.25;

epsilon=0.005;
opepsilon=1+epsilon;
vepsilon=epsilon*[1,1,1];
t=1.5+k/2;
embosst=0.6;
w=80;
hh=k*80;
kw=k*w;
rr=kw/6.5;


// baseshape, with walls adjusted by offset (inwards)
  module baseshape(off) {
    union() {
      translate([off,-(kw-2*off)/2,0]) cube([kw-2*off,kw-2*off,hh-off]);
      translate([-rr,-rr,0]) cube([rr+2+epsilon,2*rr-2*off,hh/3-off]);
      translate([-rr,0,0]) cylinder(h=hh/3-off,r=rr-off);
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
      translate([0,-kw/2,0]) rotate([0,0,a+aoff]) 
        translate([0,-kfac*k,0]) cylinder(h=kw, r=1.1*t);
  }
  
  module permeablebase() {
    // curved holed inside water filter bit
    rr0=kw/3;
    rr1=kw;
    c0=t;
    c1=t+rr1-rr0;
    ad=360/10;
      
    difference()
      {
        translate([0,-kw/2,0]) intersection()
        {
          difference() {
            translate([0,0,c0]) cylinder(h=c1-c0,r1=rr0,r2=rr1);
            translate([0,0,c0-epsilon])
                cylinder(h=c1+2*epsilon-c0,r1=rr0-t,r2=rr1-t);
            }
            cube([kw-t/2,kw-t/2,hh]);
        }
        
        for (a=[0:360:ad]) {
            cylinderz(a,26.2,0.5*ad);
            cylinderz(a,30,0);
            cylinderz(a,35,0.5*ad);
        }
    }
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



//lion();
//leaf();