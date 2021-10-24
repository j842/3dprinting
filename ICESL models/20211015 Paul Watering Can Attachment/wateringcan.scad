cyld=25;
cyll=30;
cylt=2;

module cyl()
{   
    $fn=100;
    translate([0,0,-cyll/2+0.001])
    difference() {
      cylinder(r=cyld/2+cylt,h=cyll, center = true);
      cylinder(r=cyld/2,h=cyll+0.005, center = true);
    }
}

module spray()
{
    $fn=100;
    difference() {
        hull() {
            cylinder(h=3,r=cyld/2+cylt);
            translate([30,0,100]) rotate(a=[0,50,0]) cylinder(h=3,r=85);
        };
        hull() {
            translate([0,0,-0.005]) cylinder(h=3,r=cyld/2);
            translate([30,0,100+0.006]) rotate(a=[0,50,0]) cylinder(h=3,r=85-cylt);
        };
    }
    
    translate([30,0,100]) rotate(a=[0,50,0]) difference()
    {
        r0=4;
        h0=4;
        dh=0.05;
        cylinder(h=3,r=85);
        translate([0,0,dh]) cylinder(h=h0,r=r0);
        for ( i = [0 : 5] ){
            rotate( i * 60, [0, 0, 1])
            translate([0, 20, dh])
            cylinder(h=h0,r=r0);
        }
        for ( i = [0 : 11] ){
            rotate( i * 30, [0, 0, 1])
            translate([0, 40, dh])
            cylinder(h=h0,r=r0);
        }
        for ( i = [0 : 23] ){
            rotate( i * 15, [0, 0, 1])
            translate([0, 60, dh])
            cylinder(h=h0,r=r0);
        }
    }
}

cyl();
spray();