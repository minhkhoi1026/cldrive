//{"F":0,"cam_pos":3,"cam_pos_l":13,"fl":4,"height":2,"l_params.resolution":15,"l_params.volume":14,"m":10,"nmap":7,"params":8,"params.resolution":11,"params.volume":12,"ppt":5,"tsdf":9,"vmap":6,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct TsdfParams {
  float resolution[3];
  float volume[3];
  float mu;
};
bool _isnan3(float3 v) {
  return isnan(v.x) || isnan(v.y) || isnan(v.z);
}

bool _isnan4(float4 v) {
  return isnan(v.x) || isnan(v.y) || isnan(v.z) || isnan(v.w);
}

bool _isnan2(float2 v) {
  return isnan(v.x) || isnan(v.y);
}

void pack_tsdf(float val, float weight, global short2* tsdf, int idx) {
  short2 res = {convert_short(val * convert_float(32766)), convert_short(weight) - 32766};
  tsdf[hook(9, idx)] = res;
}

float2 unpack_tsdf(short2 tsdf) {
  float2 res = {convert_float(tsdf.x) / convert_float(32766), convert_float(tsdf.y) + convert_float(32766)};
  return res;
}

float4 mul(float4 m[4], float4 v) {
  float4 res = {m[hook(10, 0)].x * v.x + m[hook(10, 1)].x * v.y + m[hook(10, 2)].x * v.z + m[hook(10, 3)].x * v.w, m[hook(10, 0)].y * v.x + m[hook(10, 1)].y * v.y + m[hook(10, 2)].y * v.z + m[hook(10, 3)].y * v.w, m[hook(10, 0)].z * v.x + m[hook(10, 1)].z * v.y + m[hook(10, 2)].z * v.z + m[hook(10, 3)].z * v.w, m[hook(10, 0)].w * v.x + m[hook(10, 1)].w * v.y + m[hook(10, 2)].w * v.z + m[hook(10, 3)].w * v.w};
  return res;
}

float3 mul_homogenize(float4 m[4], float3 v) {
  float3 res = {m[hook(10, 0)].x * v.x + m[hook(10, 1)].x * v.y + m[hook(10, 2)].x * v.z + m[hook(10, 3)].x * 1.0f, m[hook(10, 0)].y * v.x + m[hook(10, 1)].y * v.y + m[hook(10, 2)].y * v.z + m[hook(10, 3)].y * 1.0f, m[hook(10, 0)].z * v.x + m[hook(10, 1)].z * v.y + m[hook(10, 2)].z * v.z + m[hook(10, 3)].z * 1.0f};
  return res;
}

float4 getVoxelGlobal(float voxel_x, float voxel_y, float voxel_z, float3 cellsize) {
  float4 voxel = {(voxel_x + 0.5f) * cellsize.x, (voxel_y + 0.5f) * cellsize.y, (voxel_z + 0.5f) * cellsize.z, 1.0f};
  return voxel;
}

bool isNull(float3 v) {
  return v.x == 0 && v.y == 0 && v.z == 0;
}
int3 getVoxel(float4 p, struct TsdfParams params) {
  int3 res = {convert_int(p.x * params.resolution[hook(11, 0)] / params.volume[hook(12, 0)] + params.resolution[hook(11, 0)] / 2.0f), convert_int(p.y * params.resolution[hook(11, 1)] / params.volume[hook(12, 1)] + params.resolution[hook(11, 1)] / 2.0f), convert_int(p.z * params.resolution[hook(11, 2)] / params.volume[hook(12, 2)])};

  return res;
}

float3 reflect(float3 V, float3 N) {
  return V - 2.0f * dot(V, N) * N;
}

float getTSDF(global short2* F, int3 resolution, int3 voxel, int x_offset, int y_offset, int z_offset) {
  int ox = (voxel.x + x_offset);
  int oy = (voxel.y + y_offset);
  int oz = (voxel.z + z_offset);

  int idx = ox * resolution.z + oy * resolution.x * resolution.z + oz;
  if (ox < 0 || ox >= resolution.x || oy < 0 || oy >= resolution.y || oz < 0 || oz >= resolution.z)
    return __builtin_astype((2147483647), float);

  return unpack_tsdf(F[hook(0, idx)]).x;
}

float interpolateTrilinearly(global short2* F, float4 point, int3 voxel, float3 cellsize, struct TsdfParams params) {
  int3 resolution = {convert_int(params.resolution[hook(11, 0)]), convert_int(params.resolution[hook(11, 1)]), convert_int(params.resolution[hook(11, 2)])};

  if (voxel.x <= 0 || voxel.x >= resolution.x - 1)
    return __builtin_astype((2147483647), float);

  if (voxel.y <= 0 || voxel.y >= resolution.y - 1)
    return __builtin_astype((2147483647), float);

  if (voxel.z <= 0 || voxel.z >= resolution.z - 1)
    return __builtin_astype((2147483647), float);

  float vx = ((float)voxel.x + 0.5f) * cellsize.x - params.volume[hook(12, 0)] / 2.0f;
  float vy = ((float)voxel.y + 0.5f) * cellsize.y - params.volume[hook(12, 1)] / 2.0f;
  float vz = ((float)voxel.z + 0.5f) * cellsize.z;

  voxel.x = (point.x < vx) ? (voxel.x - 1) : voxel.x;
  voxel.y = (point.y < vy) ? (voxel.y - 1) : voxel.y;
  voxel.z = (point.z < vz) ? (voxel.z - 1) : voxel.z;

  float a = (point.x - ((convert_float(voxel.x) + 0.5f) * cellsize.x - params.volume[hook(12, 0)] / 2.0f)) / cellsize.x;
  float b = (point.y - ((convert_float(voxel.y) + 0.5f) * cellsize.y - params.volume[hook(12, 1)] / 2.0f)) / cellsize.y;
  float c = (point.z - (convert_float(voxel.z) + 0.5f) * cellsize.z) / cellsize.z;

  float V000 = getTSDF(F, resolution, voxel, 0, 0, 0);
  float V001 = getTSDF(F, resolution, voxel, 0, 0, 1);
  float V010 = getTSDF(F, resolution, voxel, 0, 1, 0);
  float V011 = getTSDF(F, resolution, voxel, 0, 1, 1);
  float V100 = getTSDF(F, resolution, voxel, 1, 0, 0);
  float V101 = getTSDF(F, resolution, voxel, 1, 0, 1);
  float V110 = getTSDF(F, resolution, voxel, 1, 1, 0);
  float V111 = getTSDF(F, resolution, voxel, 1, 1, 1);

  if (isnan(V000) || isnan(V001) || isnan(V010) || isnan(V011) || isnan(V100) || isnan(V101) || isnan(V110) || isnan(V111))
    return __builtin_astype((2147483647), float);

  float res = V000 * (1.0f - a) * (1.0f - b) * (1.0f - c) + V001 * (1.0f - a) * (1.0f - b) * c + V010 * (1.0f - a) * b * (1.0f - c) + V011 * (1.0f - a) * b * c + V100 * a * (1.0f - b) * (1.0f - c) + V101 * a * (1.0f - b) * c + V110 * a * b * (1.0f - c) + V111 * a * b * c;
  return res;
}

kernel void raycast(global short2* F, global const int* width, global const int* height, global const float4* cam_pos, global const float* fl, global const float2* ppt, global float3* vmap, global float3* nmap,

                    constant struct TsdfParams* params) {
  const int u = get_global_id(0);
  const int v = get_global_id(1);

  int w = *width;
  int h = *height;

  float4 cam_pos_l[4] = {cam_pos[hook(3, 0)], cam_pos[hook(3, 1)], cam_pos[hook(3, 2)], cam_pos[hook(3, 3)]};

  float depth_march = 0.0f;
  float focal_length = *fl;

  float4 ray_start = {convert_float(u - w / 2.0f) / focal_length, convert_float(v - h / 2.0f) / focal_length, 1.0f, 1.0f};
  ray_start = mul(cam_pos_l, ray_start);
  float4 vertex_4 = ray_start;

  float4 ray_dir = normalize(vertex_4 - cam_pos_l[hook(13, 3)]);

  struct TsdfParams l_params = *params;

  int pix_idx = w * v + u;

  float step = l_params.mu * 0.8f;

  float4 ray_step = ray_dir * step;

  float3 cellsize = {l_params.volume[hook(14, 0)] / l_params.resolution[hook(15, 0)], l_params.volume[hook(14, 1)] / l_params.resolution[hook(15, 1)], l_params.volume[hook(14, 2)] / l_params.resolution[hook(15, 2)]};

  float tsdf = __builtin_astype((2147483647), float);
  int idx = 0;
  float prev_tsdf;

  int3 resolution = {convert_int(l_params.resolution[hook(15, 0)]), convert_int(l_params.resolution[hook(15, 1)]), convert_int(l_params.resolution[hook(15, 2)])};
  while (depth_march < l_params.volume[hook(14, 0)]) {
    vertex_4 += ray_step;
    depth_march += step;
    int3 voxel = getVoxel(vertex_4, l_params);

    if (voxel.z < 0 || voxel.z >= resolution.z || voxel.y < 0 || voxel.y >= resolution.y || voxel.x < 0 || voxel.x >= resolution.x) {
      continue;
    }

    int tmp_idx = voxel.z + voxel.x * resolution.z + voxel.y * resolution.x * resolution.z;

    if (tmp_idx == idx)
      continue;
    idx = tmp_idx;

    prev_tsdf = tsdf;
    tsdf = F[hook(0, idx)].x;

    if (isnan(tsdf) || isnan(prev_tsdf))
      continue;

    if (prev_tsdf < 0.0f && tsdf > 0.0f)
      break;

    if (prev_tsdf >= 0.0f && tsdf <= 0.0f) {
      float Ftdt = interpolateTrilinearly(F, vertex_4, voxel, cellsize, l_params);
      if (isnan(Ftdt))
        break;

      float4 prev_vertex = vertex_4 - ray_step;
      int3 prev_voxel = getVoxel(prev_vertex, l_params);

      float Ft = interpolateTrilinearly(F, prev_vertex, prev_voxel, cellsize, l_params);
      if (isnan(Ft))
        break;

      if (Ftdt > 0.0f && Ft > 0.0f)
        continue;
      if (Ftdt < 0.0f && Ft < 0.0f)
        break;

      float Ts = (depth_march - step) - step * Ft / (Ftdt - Ft);

      float4 v_res = ray_start + ray_dir * Ts;

      vmap[hook(6, pix_idx)].x = v_res.x;
      vmap[hook(6, pix_idx)].y = v_res.y;
      vmap[hook(6, pix_idx)].z = v_res.z;

      float4 t;
      float3 n;

      t = v_res;
      t.x += cellsize.x;
      float Fx1 = interpolateTrilinearly(F, t, getVoxel(t, l_params), cellsize, l_params);

      if (isnan(Fx1))
        break;

      t = v_res;
      t.x -= cellsize.x;
      float Fx2 = interpolateTrilinearly(F, t, getVoxel(t, l_params), cellsize, l_params);

      if (isnan(Fx2))
        break;

      n.x = (Fx2 - Fx1);

      t = v_res;
      t.y += cellsize.y;
      float Fy1 = interpolateTrilinearly(F, t, getVoxel(t, l_params), cellsize, l_params);

      if (isnan(Fy1))
        break;

      t = v_res;
      t.y -= cellsize.y;
      float Fy2 = interpolateTrilinearly(F, t, getVoxel(t, l_params), cellsize, l_params);

      if (isnan(Fy2))
        break;

      n.y = (Fy2 - Fy1);

      t = v_res;
      t.z += cellsize.z;
      float Fz1 = interpolateTrilinearly(F, t, getVoxel(t, l_params), cellsize, l_params);

      if (isnan(Fz1))
        break;

      t = v_res;
      t.z -= cellsize.z;
      float Fz2 = interpolateTrilinearly(F, t, getVoxel(t, l_params), cellsize, l_params);

      if (isnan(Fz2))
        break;

      n.z = (Fz2 - Fz1);

      n = normalize(n);

      nmap[hook(7, pix_idx)] = n;
      return;
    }
  }

  vmap[hook(6, pix_idx)] = __builtin_astype((2147483647), float);
  nmap[hook(7, pix_idx)] = __builtin_astype((2147483647), float);
}