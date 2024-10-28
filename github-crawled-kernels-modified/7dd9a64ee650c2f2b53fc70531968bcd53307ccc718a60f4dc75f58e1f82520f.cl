//{"coordinates":0,"label":7,"nrOfTriangles":2,"segmentation":3,"spacingX":4,"spacingY":5,"spacingZ":6,"triangles":1}
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

int rayIntersectsTriangle(float3 p, float3 d, float3 v0, float3 v1, float3 v2) {
  float3 e1, e2, h, s, q;
  float a, f, u, v;
  e1 = v1 - v0;
  e2 = v2 - v0;

  h = cross(d, e2);
  a = dot(e1, h);

  if (a > -0.00000000001f && a < 0.00000000001f)
    return 0;

  f = 1.0f / a;
  s = p - v0;
  u = f * (dot(s, h));

  if (u < 0.0 || u > 1.0)
    return 0;

  q = cross(s, e1);
  v = f * dot(d, q);

  if (v < 0.0 || u + v > 1.0)
    return 0;

  float t = f * dot(e2, q);

  if (t > 0.00000001f) {
    return 1;

  } else {
    return 0;
  }
}

kernel void mesh_to_segmentation_3d(global float* coordinates, global unsigned int* triangles, private int nrOfTriangles, global uchar* segmentation, private float spacingX, private float spacingY, private float spacingZ, private uchar label) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  int intersections = 0;

  float3 P0 = {pos.x * spacingX, pos.y * spacingY, pos.z * spacingZ};
  if (P0.y == 0) {
    P0.y = 0.00001;
  }

  float3 P1 = P0;
  P1.x += 0.1;

  for (int i = 0; i < nrOfTriangles; ++i) {
    const uint3 triangle = vload3(i, triangles);
    const float3 u = vload3(triangle.x, coordinates);
    const float3 v = vload3(triangle.y, coordinates);
    const float3 w = vload3(triangle.z, coordinates);

    if (rayIntersectsTriangle(P0, P1, u, v, w) >= 1) {
      intersections += 1;
    }
  }

  segmentation[hook(3, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = intersections % 2 == 0 ? 0 : label;
}