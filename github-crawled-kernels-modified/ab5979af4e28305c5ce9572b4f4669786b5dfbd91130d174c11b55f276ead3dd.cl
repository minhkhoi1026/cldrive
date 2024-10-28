//{"depth_map":3,"dim":1,"normal_map":4,"val":2,"vol":0}
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

float2 get_df(global float2* vol, int3 dim, float3 v) {
  int3 p = clamp(convert_int3_rtn(v), (int3)(0), dim - 1);
  return vol[hook(0, p.x + p.y * dim.x + p.z * dim.x * dim.y)];
}

float get_df_c(global float2* vol, int3 dim, float3 v) {
  v -= 0.5f;
  float3 i = floor(v);
  float3 f = v - i;

  float e000 = get_df(vol, dim, i + (float3)(0.0, 0.0, 0.0)).x;
  float e100 = get_df(vol, dim, i + (float3)(1.0, 0.0, 0.0)).x;
  float e010 = get_df(vol, dim, i + (float3)(0.0, 1.0, 0.0)).x;
  float e110 = get_df(vol, dim, i + (float3)(1.0, 1.0, 0.0)).x;

  float e001 = get_df(vol, dim, i + (float3)(0.0, 0.0, 1.0)).x;
  float e101 = get_df(vol, dim, i + (float3)(1.0, 0.0, 1.0)).x;
  float e011 = get_df(vol, dim, i + (float3)(0.0, 1.0, 1.0)).x;
  float e111 = get_df(vol, dim, i + (float3)(1.0, 1.0, 1.0)).x;

  float e00 = f.x * (e100 - e000) + e000;
  float e10 = f.x * (e110 - e010) + e010;
  float e01 = f.x * (e101 - e001) + e001;
  float e11 = f.x * (e111 - e011) + e011;

  float e0 = f.y * (e10 - e00) + e00;
  float e1 = f.y * (e11 - e01) + e01;

  float e = f.z * (e1 - e0) + e0;

  return e;
}

float3 get_grad(global float2* vol, int3 dim, float3 v) {
  float3 s = (float3)(1.0, 0.0, 0.0);

  float3 n = (float3)(get_df_c(vol, dim, v + s.xyz) - get_df_c(vol, dim, v - s.xyz), get_df_c(vol, dim, v + s.zxy) - get_df_c(vol, dim, v - s.zxy), get_df_c(vol, dim, v + s.yzx) - get_df_c(vol, dim, v - s.yzx));
  return normalize(n);
}

kernel void df_clear(global float2* vol, int3 dim, float2 val) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= dim.x || y >= dim.y || z >= dim.z) {
    return;
  }

  int index = x + y * dim.x + z * dim.x * dim.y;

  vol[hook(0, index)] = val;
}