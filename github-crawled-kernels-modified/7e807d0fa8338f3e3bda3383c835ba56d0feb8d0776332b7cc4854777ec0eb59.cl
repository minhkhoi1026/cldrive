//{"a":12,"b":13,"epsilon_d":4,"epsilon_theta":5,"height":8,"k":6,"lmats":10,"map":0,"mats":9,"ms":11,"prev_map":1,"t_frame_frame":2,"t_z":3,"width":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float3 matrixmul3(const constant float* m, float3 v) {
  float3 retr;
  retr.x = dot(vload3(0, m), v);
  retr.y = dot(vload3(1, m), v);
  retr.z = dot(vload3(2, m), v);

  return retr;
}

float4 matrixmul4(const constant float* m, float4 v) {
  float4 retr;
  retr.x = dot(vload4(0, m), v);
  retr.y = dot(vload4(1, m), v);
  retr.z = dot(vload4(2, m), v);
  retr.w = dot(vload4(3, m), v);

  return retr;
}

int is_finite(float3 v) {
  return isfinite(v.x) && isfinite(v.y) && isfinite(v.z);
}

void zero_ab(local float* ms) {
  for (size_t i = 0; i < (27U); ++i)
    ms[hook(11, i)] = 0;
}

void icp(float3 p, float3 q, float3 n, local float* ms) {
  float3 c = cross(p, n);
  float pqn = dot(p - q, n);

  ms[hook(11, 0)] = c.x * c.x;
  ms[hook(11, 1)] = c.x * c.y;
  ms[hook(11, 2)] = c.x * c.z;
  ms[hook(11, 3)] = c.x * n.x;
  ms[hook(11, 4)] = c.x * n.y;
  ms[hook(11, 5)] = c.x * n.z;

  ms[hook(11, 6)] = c.y * c.y;
  ms[hook(11, 7)] = c.y * c.z;
  ms[hook(11, 8)] = c.y * n.x;
  ms[hook(11, 9)] = c.y * n.y;
  ms[hook(11, 10)] = c.y * n.z;

  ms[hook(11, 11)] = c.z * c.z;
  ms[hook(11, 12)] = c.z * n.x;
  ms[hook(11, 13)] = c.z * n.y;
  ms[hook(11, 14)] = c.z * n.z;

  ms[hook(11, 15)] = n.x * n.x;
  ms[hook(11, 16)] = n.x * n.y;
  ms[hook(11, 17)] = n.x * n.z;

  ms[hook(11, 18)] = n.y * n.y;
  ms[hook(11, 19)] = n.y * n.z;

  ms[hook(11, 20)] = n.z * n.z;

  pqn *= -1;
  ms[hook(11, 21)] = c.x * pqn;
  ms[hook(11, 22)] = c.y * pqn;
  ms[hook(11, 23)] = c.z * pqn;
  ms[hook(11, 24)] = n.x * pqn;
  ms[hook(11, 25)] = n.y * pqn;
  ms[hook(11, 26)] = n.z * pqn;
}

void correspondences_impl(const global float* map, const global float* prev_map, const constant float* t_frame_frame, const constant float* t_z, float epsilon_d, float epsilon_theta, const constant float* k, size_t x, size_t y, size_t width, size_t height, local float* ms) {
  size_t idx = (y * width) + x;
  idx *= 2U;

  float3 curr_v = vload3(idx, map);
  float3 curr_n = vload3(idx + 1U, map);
  if (!is_finite(curr_v) || !is_finite(curr_n)) {
    zero_ab(ms);
    return;
  }

  float4 curr_v_homo = (float4)(curr_v, 1);

  float4 v_pc_h = matrixmul4(t_frame_frame, curr_v_homo);

  float3 v_pc = (float3)(v_pc_h.x, v_pc_h.y, v_pc_h.z);
  float3 uv3 = matrixmul3(k, v_pc);

  int2 u = (int2)(round(uv3.x / uv3.z), round(uv3.y / uv3.z));

  if ((u.x < 0) || (u.y < 0) || (((size_t)u.x) >= width) || (((size_t)u.y) >= height)) {
    zero_ab(ms);
    return;
  }

  size_t lin_idx = u.x + u.y * width;

  lin_idx *= 2U;
  float3 curr_pv = vload3(lin_idx, prev_map);
  float3 curr_pn = vload3(lin_idx + 1U, prev_map);

  if (!(is_finite(curr_pv) && is_finite(curr_pn))) {
    zero_ab(ms);
    return;
  }

  float4 curr_pv_homo = (float4)(curr_pv, 1);
  float4 t_z_curr_v_homo = matrixmul4(t_z, curr_v_homo);
  float4 t_z_curr_v_homo_curr_pv_homo = t_z_curr_v_homo - curr_pv_homo;
  float3 t_z_curr_v = (float3)(t_z_curr_v_homo.x, t_z_curr_v_homo.y, t_z_curr_v_homo.z);
  if (fast_length(t_z_curr_v_homo_curr_pv_homo) > epsilon_d) {
    zero_ab(ms);
    return;
  }

  float3 r_z_curr_n;
  r_z_curr_n.x = (t_z[hook(3, 0)] * curr_n.x) + (t_z[hook(3, 1)] * curr_n.y) + (t_z[hook(3, 2)] * curr_n.z);
  r_z_curr_n.y = (t_z[hook(3, 4)] * curr_n.x) + (t_z[hook(3, 5)] * curr_n.y) + (t_z[hook(3, 6)] * curr_n.z);
  r_z_curr_n.z = (t_z[hook(3, 8)] * curr_n.x) + (t_z[hook(3, 9)] * curr_n.y) + (t_z[hook(3, 10)] * curr_n.z);
  float3 crzcncpn = cross(r_z_curr_n, curr_pn);
  if (fast_length(crzcncpn) > epsilon_theta) {
    zero_ab(ms);
    return;
  }

  icp(t_z_curr_v, curr_pv, curr_pn, ms);
}

void parallel_sum_impl(size_t l, size_t size, global float* dest, local float* lmats) {
  for (size_t stride = size / 2U; stride > 0; stride /= 2U) {
    barrier(0x01);

    if (l >= stride)
      continue;

    local float* a = lmats + (l * (27U));
    const local float* b = lmats + ((l + stride) * (27U));
    for (size_t i = 0; i < (27U); ++i)
      a[hook(12, i)] += b[hook(13, i)];
  }

  if (l != 0)
    return;
  for (size_t i = 0; i < (27U); ++i, ++dest)
    *dest = lmats[hook(10, i)];
}

kernel void correspondences(const global float* map, const global float* prev_map, const constant float* t_frame_frame, const constant float* t_z, float epsilon_d, float epsilon_theta, const constant float* k, unsigned int width, unsigned int height, global float* mats, local float* lmats) {
  size_t idx = get_global_id(0);
  size_t x = idx % width;
  size_t y = idx / width;
  size_t l = get_local_id(0);

  correspondences_impl(map, prev_map, t_frame_frame, t_z, epsilon_d, epsilon_theta, k, x, y, width, height, lmats + ((27U) * l));

  parallel_sum_impl(l, get_local_size(0), mats + (get_group_id(0) * (27U)), lmats);
}