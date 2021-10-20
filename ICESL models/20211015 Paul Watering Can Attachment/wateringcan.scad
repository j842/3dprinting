cyld=25;
cyll=30;
cylt=2;

module cyl()
{
    difference() {
      cylinder(r=cyld/2+cylt,h=cyll, center = true,$fn=100);
      cylinder(r=cyld/2,h=cyll+0.002, center = true,$fn=100);
    }
}

cyl();