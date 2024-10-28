//{"batch_width":4,"best_inliers":5,"counts":1,"d":0,"d_len":1,"f":21,"fund_mat":4,"in":0,"inlier_mask":5,"inliers":0,"iter_len":2,"iters_per_batch":2,"local_best_count":6,"matches":2,"out":1,"p_matched_size":3,"sums":4,"thresh":3,"threshold":2,"tmp":4,"weight":3,"work_items_per_F":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct match_t {
  float u1p;
  float v1p;
  float u1c;
  float v1c;
};

kernel __attribute__((reqd_work_group_size(128, 1, 1))) void find_inliers(const unsigned int p_matched_size, const unsigned int work_items_per_F, global const struct match_t* restrict matches, const float thresh, global const double* restrict fund_mat, global uchar* restrict inlier_mask) {
  local float f[9];
  const size_t sub_iter_id = get_global_id(0) % (work_items_per_F);

  if (get_local_id(0) < 9) {
    const size_t iter_id = get_global_id(0) / work_items_per_F;
    f[hook(21, get_local_id(0))] = fund_mat[hook(4, iter_id * 9 + get_local_id(0))];
  }

  barrier(0x01);

  if (sub_iter_id < p_matched_size) {
    float f00 = f[hook(21, 0)];
    float f01 = f[hook(21, 1)];
    float f02 = f[hook(21, 2)];
    float f10 = f[hook(21, 3)];
    float f11 = f[hook(21, 4)];
    float f12 = f[hook(21, 5)];
    float f20 = f[hook(21, 6)];
    float f21 = f[hook(21, 7)];
    float f22 = f[hook(21, 8)];

    struct match_t match = matches[hook(2, sub_iter_id)];
    float u1 = match.u1p;
    float v1 = match.v1p;
    float u2 = match.u1c;
    float v2 = match.v1c;

    float Fx1u = f00 * u1 + f01 * v1 + f02;
    float Fx1v = f10 * u1 + f11 * v1 + f12;
    float Fx1w = f20 * u1 + f21 * v1 + f22;

    float Ftx2u = f00 * u2 + f10 * v2 + f20;
    float Ftx2v = f01 * u2 + f11 * v2 + f21;

    float x2tFx1 = u2 * Fx1u + v2 * Fx1v + Fx1w;

    float d = x2tFx1 * x2tFx1 / (Fx1u * Fx1u + Fx1v * Fx1v + Ftx2u * Ftx2u + Ftx2v * Ftx2v);

    inlier_mask[hook(5, get_global_id(0))] = fabs(d) < thresh;
  }
}

kernel __attribute__((reqd_work_group_size(128, 1, 1))) void sum(global const uchar* restrict in, global ushort* restrict out, const unsigned int iter_len, const unsigned int batch_width, local ushort* restrict tmp) {
  const size_t iter_id = get_group_id(0);
  const unsigned base_offset = iter_id * batch_width;

  ushort sum = 0;
  for (unsigned i = get_local_id(0); i < iter_len; i += get_local_size(0)) {
    sum += in[hook(0, base_offset + i)];
  }

  tmp[hook(4, get_local_id(0))] = sum;

  barrier(0x01);

  for (unsigned int stride = get_local_size(0) / 2; stride > 0; stride /= 2) {
    if (get_local_id(0) < stride) {
      tmp[hook(4, get_local_id(0))] += tmp[hook(4, get_local_id(0) + stride)];
    }

    barrier(0x01);
  }

  if (get_local_id(0) == 0) {
    out[hook(1, get_group_id(0))] = tmp[hook(4, 0)];
  }
}

kernel __attribute__((reqd_work_group_size(128, 1, 1))) void update_best_inliers(global const uchar* restrict inliers, global const ushort* restrict counts, const unsigned int iters_per_batch, const unsigned int p_matched_size, const unsigned int batch_width, global uchar* restrict best_inliers, global ushort* restrict local_best_count) {
  ushort best_count = local_best_count[hook(6, get_group_id(0))];

  int best_iter = -1;
  for (unsigned i = 0; i < iters_per_batch; i++) {
    const ushort iter_count = counts[hook(1, i)];
    if (iter_count > best_count) {
      best_iter = i;
      best_count = iter_count;
    }
  }

  barrier(0x02);

  if (get_global_id(0) < p_matched_size) {
    if (best_iter != -1) {
      best_inliers[hook(5, get_global_id(0))] = inliers[hook(0, best_iter * batch_width + get_global_id(0))];
      if (get_local_id(0) == 0)
        local_best_count[hook(6, get_group_id(0))] = best_count;
    }
  }
}

__attribute__((reqd_work_group_size(128, 1, 1))) kernel void plane_calc_sums(global const float* restrict d, const unsigned int d_len, const float threshold, const float weight, global float* restrict sums) {
  const unsigned int gid0 = get_global_id(0);
  const float d_gid0 = d[hook(0, gid0)];
  const bool active = d_gid0 > threshold;
  float sum = 0;
  for (unsigned int i = 0; i < d_len; i++) {
    const float dist = d_gid0 - d[hook(0, i)];
    const float val = exp(-dist * dist * weight);
    sum += val;
  }
  sums[hook(4, gid0)] = active ? sum : 0;
}