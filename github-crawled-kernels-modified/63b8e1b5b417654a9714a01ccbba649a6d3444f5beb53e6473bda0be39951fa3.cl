//{"colors":2,"data_points":3,"heightmap":8,"middle_colors":9,"region_indices":10,"supercolors":6,"supercount":7,"superregion_indices":11,"superregions_x":4,"superregions_y":5,"voronoi_points_x":0,"voronoi_points_y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
float myhypot(float x, float y) {
  return sqrt((x * x) + (y * y));
}

float myabs(float x) {
  if (x < 0)
    return x * -1;
  return x;
}

float manhattan(float x1, float x2, float y1, float y2) {
  return (myabs(x1 - x2) + myabs(y1 - y2));
}

kernel void voronoi(global float* voronoi_points_x, global float* voronoi_points_y, global float* colors, global int* data_points, global float* superregions_x, global float* superregions_y, global float* supercolors, global int* supercount, write_only image2d_t heightmap, global float* middle_colors, global int* region_indices, global int* superregion_indices) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int2 coord = (int2)(x, y);

  float dmin = myhypot(1023, 1023);
  float d = 0.0f;
  int voronoi_cell = 0;

  for (int i = 0; i < *data_points; i++) {
    d = manhattan(voronoi_points_x[hook(0, i)], x, voronoi_points_y[hook(1, i)], y);
    if (d < dmin) {
      dmin = d;
      voronoi_cell = i;
    }
  }

  float voronoi_color = colors[hook(2, voronoi_cell)];
  float uppercell = middle_colors[hook(9, voronoi_cell)];
  float4 outvalue;
  outvalue.x = voronoi_color;

  outvalue.z = region_indices[hook(10, voronoi_cell)];

  dmin = myhypot(1023, 1023);
  d = 0.0f;
  int super_cell = 0;

  for (int i = 0; i < *supercount; i++) {
    d = manhattan(superregions_x[hook(4, i)], x, superregions_y[hook(5, i)], y);
    if (d < dmin) {
      dmin = d;
      super_cell = i;
    }
  }

  float supercol = supercolors[hook(6, super_cell)];

  outvalue.y = supercol;

  outvalue.w = superregion_indices[hook(11, super_cell)];

  outvalue.w = 1;

  write_imagef(heightmap, coord, outvalue);
}