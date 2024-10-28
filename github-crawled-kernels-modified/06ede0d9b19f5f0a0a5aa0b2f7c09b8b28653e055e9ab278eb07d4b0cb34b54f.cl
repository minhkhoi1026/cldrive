//{"coordinates":0,"label":6,"lines":1,"nrOfLines":2,"segmentation":3,"spacingX":4,"spacingY":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
char get_line_intersection(float p0_x, float p0_y, float p1_x, float p1_y, float p2_x, float p2_y, float p3_x, float p3_y, float* i_x, float* i_y) {
  float s1_x, s1_y, s2_x, s2_y;
  s1_x = p1_x - p0_x;
  s1_y = p1_y - p0_y;
  s2_x = p3_x - p2_x;
  s2_y = p3_y - p2_y;

  float s, t;
  s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
  t = (s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);

  if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
    *i_x = p0_x + (t * s1_x);
    *i_y = p0_y + (t * s1_y);
    return 1;
  }

  return 0;
}

kernel void mesh_to_segmentation_2d(global float* coordinates, global uint2* lines, private unsigned int nrOfLines, write_only image2d_t segmentation, private float spacingX, private float spacingY, private uchar label) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  int intersections = 0;
  float x1 = pos.x * spacingX;
  float y1 = pos.y * spacingY;
  const float t = 0.00000001;

  float y2 = y1;
  for (int i = 0; i < nrOfLines; ++i) {
    float3 coordinate3 = vload3(lines[hook(1, i)].x, coordinates);
    float3 coordinate4 = vload3(lines[hook(1, i)].y, coordinates);
    float x3 = coordinate3.x;
    float y3 = coordinate3.y;
    float x4 = coordinate4.x;
    float y4 = coordinate4.y;

    if (y3 > y4) {
      float tmp = y4;
      y4 = y3;
      y3 = tmp;
      tmp = x4;
      x4 = x3;
      x3 = tmp;
    }

    if (y3 == y4) {
      continue;
    }

    float x, y;
    if (get_line_intersection(x1, y1, 0, y2, x3, y3, x4, y4, &x, &y) == 1) {
      if (fabs(x - x4) < t && fabs(y - y4) < t) {
        intersections++;
      } else if (fabs(x - x3) < t && fabs(y - y3) < t) {
      } else {
        intersections++;
      }
    }
  }

  write_imageui(segmentation, pos, intersections % 2 == 0 ? 0 : label);
}