//{"M":3,"depth_map":4,"dim":2,"normal_map":5,"p":0,"w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float get_depth(global float* depth_map, int2 dim, float2 v) {
  int2 p = clamp(convert_int2_rtn(v), (int2)(0), dim - 1);
  return depth_map[hook(4, p.x + p.y * dim.x)] * 0.001f;
}

float3 get_normal(global float3* normal_map, int2 dim, float2 v) {
  int2 p = clamp(convert_int2_rtn(v), (int2)(0), dim - 1);
  return normal_map[hook(5, p.x + p.y * dim.x)];
}

kernel void point_to_world(global float3* p, global float3* w, int2 dim, float16 M) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if (x >= dim.x || y >= dim.y) {
    return;
  }

  int index = x + y * dim.x;

  float3 v = p[hook(0, index)];

  w[hook(1, index)] = M.lo.lo.xyz * v.x + M.lo.hi.xyz * v.y + M.hi.lo.xyz * v.z + M.hi.hi.xyz;
}