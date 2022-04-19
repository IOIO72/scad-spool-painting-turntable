/*
  Parametric Spool Painting Turntable v0.6
  by IOIO72 aka Tamio Patrick Honma
  
  License: CC BY-NC-SA 4.0
  https://creativecommons.org/licenses/by-nc-sa/4.0/

  This is the parametric version of the original model for 200g filament spools:
  https://www.thingiverse.com/thing:4838023
*/


/* [Basic Parameters in millimeters] */

// The turntable diameter should equal the diameter of your spool
turntable_diameter = 150;

// The inner diameter of your spool, which is the spool's hole
spool_inner_diameter = 50;

// Print test parts to verify your measurements of the diameters and inner ring height
test_parts = false;


/* [Number of Elements] */

// Number of handles
handle_number = 5;

// Number of glide lentils
lentil_number = 8;

// Number of hooks to mount the turntable to the spool
hook_number = 2;



/* [Heights in millimeters] */

// The height of the inner ring, which goes into your spool's hole
spool_inner_height = 8;

// The height of the turntable, which is the plate itself
turntable_height = 2.5;


/* [Additional Parameters] */

// The size of the handles
handle_size = 30;

// The width of the glide ring, which contains the glide lentils
spool_glide_width = 20;

// Offset of the hook
hook_offset = 2;

// Height of the hook
hook_height = 8;

// Width of the hook
hook_width = 7;

// Test part inner ring wall size
test_wall = 0.8;

// Test part base height
test_height = 0.4;

// Number of fragments
$fn = 100; // [50:200]


/* [Hidden] */

wall_size = 2;


module ring(height,diameter,inner_diameter) {
  linear_extrude(height=height) {
    difference () {
      circle(d=diameter);
      circle(d=inner_diameter);
    };
  };
};

if (test_parts == false) {

  linear_extrude(turntable_height) {

    // Handles
    if (handle_number > 0) {
      for(n = [1 : handle_number]) {
        rotate(a=n * 360 / handle_number, v=[0, 0, 1])
        translate([turntable_diameter / 2, 0, 0])
        resize([handle_size, handle_size / 2.2])
        circle(d=100);
      };
    };

    // Turntable
    circle(d=turntable_diameter);
  };


  // Spool inner ring
  ring(spool_inner_height + turntable_height + wall_size, spool_inner_diameter, spool_inner_diameter - wall_size * 2);

  // Spool glide ring
  ring(turntable_height + wall_size, spool_inner_diameter + spool_glide_width, spool_inner_diameter);

  // Glide lentils
  if (lentil_number > 0) {
    for(n = [1 : lentil_number]) {
      rotate(a=n * 360 / lentil_number, v=[0, 0, 1])
      translate([0, (spool_inner_diameter / 2 + spool_glide_width / 4), turntable_height + wall_size / 2]) {
        difference() {
          resize([spool_glide_width / 5, spool_glide_width / 2 - wall_size, spool_glide_width / 5])
          sphere(d=spool_glide_width / 2);
          translate([0, 0, -spool_glide_width / 20])
          cube(size=[spool_glide_width / 5, spool_glide_width / 2 - wall_size, spool_glide_width / 10], center=true);
        }
      }
    };
  };

  // Hooks
  if (hook_number > 0) {
    for (n = [1 : hook_number]) {
      rotate(a=n * 360 / hook_number, v=[0, 0, 1])
      translate([0, spool_inner_diameter / 2, spool_inner_height + turntable_height + wall_size]) {
        rotate(a=270, v=[0, 1, 0])
        linear_extrude(hook_width, center=true)
        polygon([[0,-wall_size], [0,0], [1,hook_offset], [2,hook_offset], [hook_height,0], [hook_height, -wall_size], [2,hook_offset - wall_size], [1,-wall_size]]);
      };
    };
  };

} else {
  // Test Parts
  
  // Test Part for Spool inner ring
  ring(spool_inner_height + test_height, spool_inner_diameter, spool_inner_diameter - test_wall);

  // Test Part for Spool glide ring
  ring(test_height, spool_inner_diameter + spool_glide_width, spool_inner_diameter);

  // Test Part for Turntable
  ring(test_height, turntable_diameter, turntable_diameter - 2);

};
