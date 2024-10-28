//{"depth_map":3,"dim":2,"normal_map":4,"normals":1,"points":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float get_depth(global float* depth_map, int2 dim, float2 v) {
  int2 p = clamp(convert_int2_rtn(v), (int2)(0), dim - 1);
  return depth_map[hook(3, p.x + p.y * dim.x)] * 0.001f;
}

float3 get_normal(global float3* normal_map, int2 dim, float2 v) {
  int2 p = clamp(convert_int2_rtn(v), (int2)(0), dim - 1);
  return normal_map[hook(4, p.x + p.y * dim.x)];
}

kernel void point_to_normal(global float3* points, global float3* normals, int2 dim) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if (x >= dim.x || y >= dim.y) {
    return;
  }

  int index = x + y * dim.x;

  x = clamp(x, 1, dim.x - 2);
  y = clamp(y, 1, dim.y - 2);
  int k = x + y * dim.x;

  float3 s = points[hook(0, k + 1)] - points[hook(0, k - 1)];
  float3 t = points[hook(0, k + dim.x)] - points[hook(0, k - dim.x)];

  normals[hook(1, index)] = normalize(-cross(s, t));
}