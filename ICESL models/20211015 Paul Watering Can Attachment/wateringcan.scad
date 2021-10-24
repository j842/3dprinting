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
            translate([30,0,70]) rotate(a=[0,50,0]) cylinder(h=3,r=85);
        };
        hull() {
            translate([0,0,-0.005]) cylinder(h=3,r=cyld/2);
            translate([30,0,70+0.006]) rotate(a=[0,50,0]) cylinder(h=3,r=85-cylt);
        };
    }
}

cyl();
spray();