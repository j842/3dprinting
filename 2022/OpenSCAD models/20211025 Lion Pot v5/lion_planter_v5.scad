// Lion Planter v5.
// Does not need supports.

use <input/lionhead3.scad>
use <input/leaf.scad>
use <ttf/Chocolate.ttf>


printplanter=true;
printbase=false;

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
    fcx=rr+2*epsilon;
    fcy=2*rr-2*off;  
      
    union() {
      translate([off,-(kw-2*off)/2,0])
        cube([kw-2*off,kw-2*off,hh-off]);
        
      translate([-fcx+epsilon,-fcy/2,0])
        cube([fcx,fcy,hh/3-off]);

      translate([-rr,0,0]) 
        cylinder(h=hh/3-off,r=rr-off);
    }
}

// hole for water to go from spout to planter
  module spouthole() {
    shw=2*rr-2*t;
    sht=t+1;
    shh=0.05*hh/4;
    union() 
    {
      translate([t/2,0,t+shw/4])
        cube([sht,shw,shw/2],center=true);
      translate([0,0,t+shw/2]) rotate([0,90,0])
        cylinder(h=sht,r=shw/2);
    }
  }

  module cylinderz(a,kfac,aoff) {
      translate([kw/2,0,0]) rotate([0,0,a+aoff]) 
        translate([kfac*k,0,0]) cylinder(h=kw, r=0.8*t);
  }
  
  module permeablebase() {
    // curved holed inside water filter bit
    rr0=kw/4;
    rr1=rr0+0.7*kw; // rr1 <= rr0+kw
    tt0=0.7*t;
    c0=t;
    numholes=15;
    ad=360/numholes;
      
    difference()
      {
        translate([kw/2,0,0]) intersection()
        {
          difference() {
            translate([0,0,c0]) 
                cylinder(h=kw,r1=rr0,r2=rr1);
            translate([0,0,c0-epsilon])
                cylinder(h=kw,r1=rr0-tt0,r2=rr1-tt0);
            }
            translate([0,0,kw/2]) cube([kw,kw,hh],true);
        }
        
        for (a=[1:numholes]) {
            cylinderz(a*ad,19.7,0.5*ad);
            cylinderz(a*ad,23,0);
            cylinderz(a*ad,26,0.5*ad);
            cylinderz(a*ad,29,0);
        }
    }
}

module getleaf()
{
    www=5;
    translate([-epsilon,www,70*k]) 
        scale([4,k-0.25,k-0.25]) rotate([90,0,-90]) 
        leaf();
}

module frontleaves()
{
    getleaf();

    mirror([0,1,0]) getleaf();
}

module backleaves()
{
    scale([1,0.6,0.6]) mirror([1,0,0]) translate([-kw,0,0]) union()
    {
        getleaf();
        mirror([0,1,0]) getleaf();
    }
}

module closeleaves()
{
    union()
    {
        translate([0,-10*k,0]) getleaf();
        mirror([0,1,0]) translate([0,-10*k,0]) getleaf();
    }
}

module sideleaves()
{
    translate([kw/2,0,0]) rotate([0,0,90]) translate([-kw/2,0,0])
    closeleaves();
    
    translate([kw/2,0,0]) rotate([0,0,-90]) translate([-kw/2,0,0])closeleaves();
}

module embossedtext()
{
    translate([kw-0.6,0,60*k]) rotate([90,0,90]) 
    linear_extrude(t+2*epsilon){
       text("He iti,",size=6*k,halign="center",font="Chocolate");
    }
    translate([kw-0.6,0,45*k]) rotate([90,0,90]) 
    linear_extrude(t+2*epsilon){
       text("he iti kahikatoa.",size=6*k,halign="center",font="Chocolate");
    }

}

module adjustedlion()
{
    translate([-epsilon,0,55*k])
        rotate([90,0,-90]) 
        scale(0.25*k) 
        lion();
}

module pot()
{
    union() 
    {
        difference() 
        {
            baseshape(0);
            translate([0,0,t+epsilon]) baseshape(t);
            spouthole();
            embossedtext();
        }
        
        permeablebase();

        adjustedlion();

        frontleaves();
        backleaves();
        sideleaves();

    }
}

module base()
{
  bsgap=0.5; //  -- 0.5mm gap between base and platner
  bcx=kw+2*rr+2*bsgap+3*t; // base thickness t.
  bcy=kw+2*bsgap+2*t;
  bcz=3*t; // base height 2*t, base thickness t.
    
    
  intersection()
    {
        difference()
        {
           translate([kw/2-rr,0,bcz/2]) 
                cube([bcx,bcy,bcz],center=true);
            
           translate([0,0,t]) 
                baseshape(-bsgap); 
        }
        
      baseshape(-t-2*bsgap);
    }
    
}


if (printplanter) {
    pot();
}

if (printbase)
{
    if (printplanter)
    {
        translate([0,0,-2*t]) base();
    } else
    {
        base();
    }
}


