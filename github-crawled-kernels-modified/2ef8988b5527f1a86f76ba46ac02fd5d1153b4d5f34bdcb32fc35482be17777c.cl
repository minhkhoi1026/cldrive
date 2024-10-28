//{"depth_map":0,"normal_map":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float get_depth_16u(global unsigned short* depth_map, int2 dim, float2 v) {
  int2 p = clamp(convert_int2_rtn(v), (int2)(0), dim - 1);
  float d = convert_float_rtn(depth_map[hook(0, p.x + p.y * dim.x)]);

  if (d < 25.0 || d > 5000.0) {
    return (10000.0f);
  }

  if (p.x < 10 || p.x > dim.x - 10 || p.y < 10 || p.y > dim.y - 10) {
    return (10000.0f);
  }

  return d * 0.001f;
}

float3 get_normal(global float3* normal_map, int2 dim, float2 v) {
  int2 p = clamp(convert_int2_rtn(v), (int2)(0), dim - 1);
  return normal_map[hook(1, p.x + p.y * dim.x)];
}

kernel void feature_matching() {
}