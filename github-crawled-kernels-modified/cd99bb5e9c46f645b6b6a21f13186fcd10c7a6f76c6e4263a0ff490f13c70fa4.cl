//{"Kinv":3,"T_g_k":2,"extent":5,"map":1,"mu":4,"tsdf":0,"tsdf_size":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float getTsdfValue(const int3 vox, const global float* tsdf, const size_t size) {
  size_t offset = vox.x + vox.y * size + vox.z * size * size;
  float val = vload_half(offset, tsdf);

  return val;
}

int3 getVoxel(const float3 pos, const float extent, const size_t size) {
  float flt_size = size;
  float one_over_voxel_size = flt_size / extent;
  return (int3)(floor(pos.x * one_over_voxel_size), floor(pos.y * one_over_voxel_size), floor(pos.z * one_over_voxel_size));
}

int isVoxelValidAndOffBorder(const int3 vox, const size_t size, const size_t dist) {
  if (size < dist)
    return false;
  int upper = size - dist;
  int lower = dist;
  return !((vox.x < lower) || (vox.x >= upper) || (vox.y < lower) || (vox.y >= upper) || (vox.z < lower) || (vox.z >= upper));
}

int isVoxelValid(const int3 vox, const size_t size) {
  return isVoxelValidAndOffBorder(vox, size, 0);
}

float triLerp(const float3 p, const global float* tsdf, const float extent, const size_t size) {
  int3 vox = getVoxel(p, extent, size);
  if (!isVoxelValidAndOffBorder(vox, size, 1))
    return __builtin_astype((2147483647), float);

  float flt_size = size;
  float voxel_size = extent / flt_size;
  float3 vox_flt = (float3)(vox.x, vox.y, vox.z);
  float3 vox_world = (vox_flt + 0.5f) * voxel_size;

  if (p.x < vox_world.x)
    --vox.x;
  if (p.y < vox_world.y)
    --vox.y;
  if (p.z < vox_world.z)
    --vox.z;

  vox_world = (vox_flt + 0.5f) * voxel_size;

  float3 rs = (p - vox_world) / voxel_size;

  int3 v000 = (int3)(vox.x, vox.y, vox.z);
  int3 v001 = (int3)(vox.x, vox.y, vox.z + 1);
  int3 v010 = (int3)(vox.x, vox.y + 1, vox.z);
  int3 v011 = (int3)(vox.x, vox.y + 1, vox.z + 1);
  int3 v100 = (int3)(vox.x + 1, vox.y, vox.z);
  int3 v101 = (int3)(vox.x + 1, vox.y, vox.z + 1);
  int3 v110 = (int3)(vox.x + 1, vox.y + 1, vox.z);
  int3 v111 = (int3)(vox.x + 1, vox.y + 1, vox.z + 1);

  return getTsdfValue(v000, tsdf, size) * (1 - rs.x) * (1 - rs.y) * (1 - rs.z) + getTsdfValue(v001, tsdf, size) * (1 - rs.x) * (1 - rs.y) * rs.z + getTsdfValue(v010, tsdf, size) * (1 - rs.x) * rs.y * (1 - rs.z) + getTsdfValue(v011, tsdf, size) * (1 - rs.x) * rs.y * rs.z + getTsdfValue(v100, tsdf, size) * rs.x * (1 - rs.y) * (1 - rs.z) + getTsdfValue(v101, tsdf, size) * rs.x * (1 - rs.y) * rs.z + getTsdfValue(v110, tsdf, size) * rs.x * rs.y * (1 - rs.z) + getTsdfValue(v111, tsdf, size) * rs.x * rs.y * rs.z;
}
kernel void raycast(const global float* tsdf, global float* map, const global float* T_g_k, const global float* Kinv, const float mu, const float extent, const unsigned int tsdf_size) {
  size_t u = get_global_id(0);
  size_t frame_width = get_global_size(0);
  size_t v = get_global_id(1);
  size_t idx = (v * frame_width) + u;
  idx *= 2U;

  float3 camera_pos = (float3)(T_g_k[hook(2, 3)], T_g_k[hook(2, 7)], T_g_k[hook(2, 11)]);

  float4 uv_sensor;
  uv_sensor.x = Kinv[hook(3, 0)] * u + Kinv[hook(3, 1)] * v + Kinv[hook(3, 2)];
  uv_sensor.y = Kinv[hook(3, 3)] * u + Kinv[hook(3, 4)] * v + Kinv[hook(3, 5)];
  uv_sensor.z = Kinv[hook(3, 6)] * u + Kinv[hook(3, 7)] * v + Kinv[hook(3, 8)];
  uv_sensor.w = 1.0f;

  float3 uv_world;
  uv_world.x = T_g_k[hook(2, 0)] * uv_sensor.x + T_g_k[hook(2, 1)] * uv_sensor.y + T_g_k[hook(2, 2)] * uv_sensor.z + T_g_k[hook(2, 3)] * uv_sensor.w;
  uv_world.y = T_g_k[hook(2, 4)] * uv_sensor.x + T_g_k[hook(2, 5)] * uv_sensor.y + T_g_k[hook(2, 6)] * uv_sensor.z + T_g_k[hook(2, 7)] * uv_sensor.w;
  uv_world.z = T_g_k[hook(2, 8)] * uv_sensor.x + T_g_k[hook(2, 9)] * uv_sensor.y + T_g_k[hook(2, 10)] * uv_sensor.z + T_g_k[hook(2, 11)] * uv_sensor.w;

  float3 ray_dir = fast_normalize(uv_world - camera_pos);

  float3 initial_ray = camera_pos + (0.4f) * ray_dir;

  int3 vox = getVoxel(initial_ray, extent, tsdf_size);
  if (!isVoxelValid(vox, tsdf_size)) {
    vstore3(__builtin_astype((2147483647), float), idx, map);
    vstore3(__builtin_astype((2147483647), float), idx + 1U, map);

    return;
  }
  float tsdf_val = getTsdfValue(vox, tsdf, tsdf_size);
  float flt_size = tsdf_size;
  float cell_size = extent / flt_size;

  for (float dist = (0.0005f); dist < (8.0f); dist += (0.0005f)) {
    float3 where = initial_ray + (ray_dir * dist);

    float tsdf_val_prev = tsdf_val;
    vox = getVoxel(where, extent, tsdf_size);
    if (!isVoxelValid(vox, tsdf_size))
      break;
    tsdf_val = getTsdfValue(vox, tsdf, tsdf_size);

    if (isnan(tsdf_val))
      continue;
    if (isnan(tsdf_val_prev))
      continue;

    int p = signbit(tsdf_val_prev);
    int c = signbit(tsdf_val);
    if (p == c)
      continue;

    if (p)
      break;

    float ftdt = triLerp(where, tsdf, extent, tsdf_size);
    if (isnan(ftdt))
      break;

    float3 last = where - (ray_dir * (0.0005f));
    float ft = triLerp(last, tsdf, extent, tsdf_size);
    if (isnan(ft))
      break;

    float t_star = dist - ((0.0005f) * ft) / (ftdt - ft);

    float3 v = initial_ray + (ray_dir * t_star);
    vstore3(v, idx, map);

    if (!isVoxelValidAndOffBorder(getVoxel(last, extent, tsdf_size), tsdf_size, 2)) {
      vstore3(__builtin_astype((2147483647), float), idx + 1U, map);
      return;
    }

    float3 t = v;
    t.x += cell_size;
    float fx1 = triLerp(t, tsdf, extent, tsdf_size);
    t = v;
    t.x -= cell_size;
    float fx2 = triLerp(t, tsdf, extent, tsdf_size);

    t = v;
    t.y += cell_size;
    float fy1 = triLerp(t, tsdf, extent, tsdf_size);
    t = v;
    t.y -= cell_size;
    float fy2 = triLerp(t, tsdf, extent, tsdf_size);

    t = v;
    t.z += cell_size;
    float fz1 = triLerp(t, tsdf, extent, tsdf_size);
    t = v;
    t.z -= cell_size;
    float fz2 = triLerp(t, tsdf, extent, tsdf_size);

    float3 n = (float3)(fx1 - fx2, fy1 - fy2, fz1 - fz2);
    float3 nullv = (float3)(0, 0, 0);
    vstore3((n == nullv) ? __builtin_astype((2147483647), float) : fast_normalize(n), idx + 1U, map);

    return;
  }

  vstore3(__builtin_astype((2147483647), float), idx, map);
  vstore3(__builtin_astype((2147483647), float), idx + 1U, map);
}