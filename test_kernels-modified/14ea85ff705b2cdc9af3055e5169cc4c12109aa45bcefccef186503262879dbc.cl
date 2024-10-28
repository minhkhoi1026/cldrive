//{"A":11,"cam_est_pose":1,"corresp":2,"m":9,"nmap_prev":5,"sumA":6,"sumB":7,"tempA":10,"tempB":12,"tsdf":8,"vmap":3,"vmap_prev":4,"width":0}
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
  tsdf[hook(8, idx)] = res;
}

float2 unpack_tsdf(short2 tsdf) {
  float2 res = {convert_float(tsdf.x) / convert_float(32766), convert_float(tsdf.y) + convert_float(32766)};
  return res;
}

float4 mul(float4 m[4], float4 v) {
  float4 res = {m[hook(9, 0)].x * v.x + m[hook(9, 1)].x * v.y + m[hook(9, 2)].x * v.z + m[hook(9, 3)].x * v.w, m[hook(9, 0)].y * v.x + m[hook(9, 1)].y * v.y + m[hook(9, 2)].y * v.z + m[hook(9, 3)].y * v.w, m[hook(9, 0)].z * v.x + m[hook(9, 1)].z * v.y + m[hook(9, 2)].z * v.z + m[hook(9, 3)].z * v.w, m[hook(9, 0)].w * v.x + m[hook(9, 1)].w * v.y + m[hook(9, 2)].w * v.z + m[hook(9, 3)].w * v.w};
  return res;
}

float3 mul_homogenize(float4 m[4], float3 v) {
  float3 res = {m[hook(9, 0)].x * v.x + m[hook(9, 1)].x * v.y + m[hook(9, 2)].x * v.z + m[hook(9, 3)].x * 1.0f, m[hook(9, 0)].y * v.x + m[hook(9, 1)].y * v.y + m[hook(9, 2)].y * v.z + m[hook(9, 3)].y * 1.0f, m[hook(9, 0)].z * v.x + m[hook(9, 1)].z * v.y + m[hook(9, 2)].z * v.z + m[hook(9, 3)].z * 1.0f};
  return res;
}

float4 getVoxelGlobal(float voxel_x, float voxel_y, float voxel_z, float3 cellsize) {
  float4 voxel = {(voxel_x + 0.5f) * cellsize.x, (voxel_y + 0.5f) * cellsize.y, (voxel_z + 0.5f) * cellsize.z, 1.0f};
  return voxel;
}

bool isNull(float3 v) {
  return v.x == 0 && v.y == 0 && v.z == 0;
}
void summand(int px, int idx, int w, global const float4* cam_est_pose, global const float2* corresp, global const float3* vmap, global const float3* vmap_prev, global const float3* nmap_prev, local float* tempA, local float* tempB) {
  float2 corresp_p = corresp[hook(2, px)];
  float3 v_prev = vmap_prev[hook(4, px)];
  float3 n_prev = nmap_prev[hook(5, px)];
  bool ok = true;

  ok = !_isnan2(corresp_p) && !_isnan3(v_prev) && !_isnan3(n_prev);

  int corresp_idx = ok ? (w * convert_int(corresp_p.y) + convert_int(corresp_p.x)) : 0;
  float3 corresp_v = vmap[hook(3, corresp_idx)];

  ok = ok && !_isnan3(corresp_v) && !isNull(corresp_v);

  if (ok) {
    float4 est_pose_loc[4] = {cam_est_pose[hook(1, 0)], cam_est_pose[hook(1, 1)], cam_est_pose[hook(1, 2)], cam_est_pose[hook(1, 3)]};

    corresp_v = mul_homogenize(est_pose_loc, corresp_v);

    float3 c = cross(n_prev, corresp_v);
    float A[6] = {c.x, c.y, c.z, n_prev.x, n_prev.y, n_prev.z};

    int k = 0;
    for (int i = 0; i < 6; i++) {
      for (int j = i; j < 6; j++)
        tempA[hook(10, idx * 21 + (k++))] = A[hook(11, i)] * A[hook(11, j)];
    }

    float b = dot(n_prev, v_prev - corresp_v);

    for (int i = 0; i < 6; i++)
      tempB[hook(12, idx * 6 + i)] = A[hook(11, i)] * b;
  } else {
    for (int k = 0; k < 21; k++)
      tempA[hook(10, idx * 21 + k)] = 0.0f;
    for (int i = 0; i < 6; i++)
      tempB[hook(12, idx * 6 + i)] = 0.0f;
  }
}

void reduce(int local_id, int thid, local float* tempA, local float* tempB, global float* sumA, global float* sumB, int local_size, int n) {
  int offset = 1;

  for (int d = n >> 1; d > 0; d >>= 1) {
    barrier(0x01);

    if (local_id < d) {
      int ai = offset * (2 * local_id + 1) - 1;
      int bi = offset * (2 * local_id + 2) - 1;

      for (int i = 0; i < 21; i++)
        tempA[hook(10, bi * 21 + i)] += tempA[hook(10, ai * 21 + i)];
      for (int i = 0; i < 6; i++)
        tempB[hook(12, bi * 6 + i)] += tempB[hook(12, ai * 6 + i)];
    }
    offset *= 2;
  }

  barrier(0x01);

  if (local_id == 0) {
    int group = thid / local_size;

    for (int i = 0; i < 21; i++)
      sumA[hook(6, group * 21 + i)] = tempA[hook(10, (n - 1) * 21 + i)];
    for (int i = 0; i < 6; i++)
      sumB[hook(7, group * 6 + i)] = tempB[hook(12, (n - 1) * 6 + i)];
  }
}

kernel void compute_block_sums(global const int* width, global const float4* cam_est_pose, global const float2* corresp, global const float3* vmap,

                               global const float3* vmap_prev, global const float3* nmap_prev, global float* sumA, global float* sumB) {
  local float tempA[2 * 64 * 21];
  local float tempB[2 * 64 * 6];
  const int local_id = get_local_id(0);
  const int thid = get_global_id(0);

  int w = *width;

  summand(thid * 2, 2 * local_id, w, cam_est_pose, corresp, vmap, vmap_prev, nmap_prev, tempA, tempB);
  summand(thid * 2 + 1, 2 * local_id + 1, w, cam_est_pose, corresp, vmap, vmap_prev, nmap_prev, tempA, tempB);

  reduce(local_id, thid, tempA, tempB, sumA, sumB, 64, 64 * 2);
}