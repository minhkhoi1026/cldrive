//{"K":5,"L":7,"M":6,"depth_map":2,"map_dim":4,"normal_map":3,"vol":0,"vol_dim":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float get_depth(global float* depth_map, int2 dim, float2 v) {
  int2 p = clamp(convert_int2_rtn(v), (int2)(0), dim - 1);
  return depth_map[hook(2, p.x + p.y * dim.x)] * 0.001f;
}

float3 get_normal(global float3* normal_map, int2 dim, float2 v) {
  int2 p = clamp(convert_int2_rtn(v), (int2)(0), dim - 1);
  return normal_map[hook(3, p.x + p.y * dim.x)];
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

kernel void df_fuse(global float2* vol, int3 vol_dim, global float* depth_map, global float3* normal_map, int2 map_dim, float4 K, float16 M, float4 L) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  int3 pos = (int3)(x, y, z);
  int index = pos.x + pos.y * vol_dim.x + pos.z * vol_dim.x * vol_dim.y;
  if (pos.x >= vol_dim.x || pos.y >= vol_dim.y || pos.z >= vol_dim.z) {
    return;
  }

  float3 world_v = (convert_float3(pos) + 0.5f) * L.w + L.xyz;

  float3 view_v = world_v - M.hi.hi.xyz;
  view_v = (float3)(dot(view_v, M.lo.lo.xyz), dot(view_v, M.lo.hi.xyz), dot(view_v, M.hi.lo.xyz));
  float3 dir = normalize(view_v);

  float proj_z = view_v.z;
  float2 proj_v = view_v.xy / proj_z;
  proj_v *= K.hi;
  proj_v += K.lo;

  if (proj_v.x < 0.0 || proj_v.y < 0.0 || proj_v.x >= map_dim.x || proj_v.y >= map_dim.y) {
    return;
  }

  float3 n = get_normal(normal_map, map_dim, proj_v);

  float dot_dir_n = -dot(dir, n);
  if (dot_dir_n < 0.2) {
    return;
  }
  dot_dir_n /= dir.z;

  float surf_z = get_depth(depth_map, map_dim, proj_v);

  float d = (surf_z - proj_z) * dot_dir_n / L.w;
  float w = dot_dir_n / proj_z * L.w;

  if (d < -(3.0f) || w <= 0.0) {
    return;
  }

  float2 df = vol[hook(0, index)];
  df.x = (df.x * df.y + d * w) / (df.y + w);
  df.y += w;

  df.x = clamp(df.x, -(3.0f), (3.0f));
  df.y = min(df.y, (2.0f));

  vol[hook(0, index)] = df;
}