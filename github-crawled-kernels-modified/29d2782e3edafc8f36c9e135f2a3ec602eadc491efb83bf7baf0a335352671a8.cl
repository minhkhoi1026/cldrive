//{"K":4,"L":6,"M":5,"col":0,"col_dim":1,"depth_map":7,"normal_map":8,"vol":2,"vol_dim":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float get_depth(global float* depth_map, int2 dim, float2 v) {
  int2 p = clamp(convert_int2_rtn(v), (int2)(0), dim - 1);
  return depth_map[hook(7, p.x + p.y * dim.x)] * 0.001f;
}

float3 get_normal(global float3* normal_map, int2 dim, float2 v) {
  int2 p = clamp(convert_int2_rtn(v), (int2)(0), dim - 1);
  return normal_map[hook(8, p.x + p.y * dim.x)];
}

float2 get_df(global float2* vol, int3 dim, float3 v) {
  int3 p = clamp(convert_int3_rtn(v), (int3)(0), dim - 1);
  return vol[hook(2, p.x + p.y * dim.x + p.z * dim.x * dim.y)];
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

float2 ray_vs_bound(float3 o, float3 inv, float3 bmin, float3 bmax, float2 e) {
  float3 s = (bmin - o) * inv;
  float3 t = (bmax - o) * inv;
  float3 a = min(s, t);
  float3 b = max(s, t);
  return (float2)(max(max(e.x, a.x), max(a.y, a.z)), min(min(e.y, b.x), min(b.y, b.z)));
}

float ray_vs_df(global float2* vol, int3 dim, float3 o, float3 dir, float2 e) {
  float t = e.x;
  float last_d = (3.0f);

  for (int i = 0; i < 1500; i++) {
    t += 1.0f;
    if (t >= e.y) {
      break;
    }

    float3 v = o + dir * t;
    float2 d = get_df(vol, dim, v);
    if (d.x <= 0.0 && d.y > 0.0) {
      t -= (d.x / (d.x - last_d));
      break;
    }
    last_d = d.x;
  }

  return t;
}

float3 gen_ray(float4 K, float16 M, float4 L, float2 p, float3* o, float3* dir) {
  p -= K.lo;
  p /= K.hi;

  *dir = normalize(p.x * M.lo.lo.xyz + p.y * M.lo.hi.xyz - M.hi.lo.xyz);
  *o = (M.hi.hi.xyz - L.xyz) / L.w;
}

kernel void ray_cast(global float4* col, int2 col_dim, global float2* vol, int3 vol_dim, float4 K, float16 M, float4 L) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if (x >= col_dim.x || y >= col_dim.y) {
    return;
  }

  int index = x + y * col_dim.x;

  float3 o, dir;
  gen_ray(K, M, L, (float2)(x, y) + 0.5f, &o, &dir);
  float3 inv = 1.0f / dir;

  float2 e = ray_vs_bound(o, inv, (float3)(0.0), convert_float3_rtn(vol_dim), (float2)(0.0, (100000.0f)));
  if (e.x >= e.y) {
    col[hook(0, index)] = (float4)(0.0);
    return;
  }

  float d = ray_vs_df(vol, vol_dim, o, dir, e);
  if (d >= e.y) {
    col[hook(0, index)] = (float4)(0.0, 0.0, 0.0, 0.0);
    return;
  }

  float3 v = o + dir * d;
  float3 n = get_grad(vol, vol_dim, v);
  col[hook(0, index)] = (float4)((float3)(dot(n, -dir)), 1.0);
}