//{"d_matching_cost":0,"d_scost":1,"height":3,"lcost_sh":7,"minCostNext":5,"sh":4,"values":6,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int get_idx_x_0(int width, int j) {
  return j;
}
inline int get_idx_y_0(int height, int i) {
  return i;
}
inline int get_idx_x_4(int width, int j) {
  return width - 1 - j;
}
inline int get_idx_y_4(int height, int i) {
  return i;
}
inline int get_idx_x_2(int width, int j) {
  return j;
}
inline int get_idx_y_2(int height, int i) {
  return i;
}
inline int get_idx_x_6(int width, int j) {
  return j;
}
inline int get_idx_y_6(int height, int i) {
  return height - 1 - i;
}

inline void init_lcost_sh_128(local ushort2* sh) {
  sh[hook(4, 128 * get_local_id(1) / 2 + get_local_id(0) * 2 + 0)] = (ushort2)(0);
  sh[hook(4, 128 * get_local_id(1) / 2 + get_local_id(0) * 2 + 1)] = (ushort2)(0);
  barrier(0x01);
}

inline int min_warp(local ushort* minCostNext) {
  int local_index = get_local_id(0) + get_local_id(1) * 32;
  barrier(0x01);
  for (int offset = 32 / 2; offset > 0; offset = offset / 2) {
    if (get_local_id(0) < offset) {
      ushort other = minCostNext[hook(5, local_index + offset)];
      ushort mine = minCostNext[hook(5, local_index)];
      minCostNext[hook(5, local_index)] = (mine < other) ? mine : other;
    }
    barrier(0x01);
  }

  return minCostNext[hook(5, get_local_id(1) * 32)];
}

inline int min_warp_int(local int* values) {
  int local_index = get_local_id(0) + get_local_id(1) * 32;
  barrier(0x01);
  for (int offset = 32 / 2; offset > 0; offset = offset / 2) {
    if (get_local_id(0) < offset) {
      int other = values[hook(6, local_index + offset)];
      int mine = values[hook(6, local_index)];
      values[hook(6, local_index)] = (mine < other) ? mine : other;
    }
    barrier(0x01);
  }

  return values[hook(6, get_local_id(1) * 32)];
}

inline int stereo_loop_128(int i, int j, global const uchar4* d_matching_cost, global ushort* d_scost, int width, int height, int minCost, local ushort2* lcost_sh, local ushort* minCostNext) {
  int idx = i * width + j;
  int k = get_local_id(0);
  int shIdx = 128 * get_local_id(1) / 2 + 2 * k;

  uchar4 diff_tmp = d_matching_cost[hook(0, idx * 128 / 4 + k)];

  ushort2 v_diff_L = (ushort2)(diff_tmp.y, diff_tmp.x);
  ushort2 v_diff_H = (ushort2)(diff_tmp.w, diff_tmp.z);

  ushort2 lcost_sh_curr_L = lcost_sh[hook(7, shIdx + 0)];
  ushort2 lcost_sh_curr_H = lcost_sh[hook(7, shIdx + 1)];
  ushort2 lcost_sh_prev, lcost_sh_next;

  if (shIdx + 2 < 128 * 8 / 2)
    lcost_sh_next = lcost_sh[hook(7, shIdx + 2)];
  else
    lcost_sh_next = lcost_sh_curr_H;

  if (shIdx - 1 > 0)
    lcost_sh_prev = lcost_sh[hook(7, shIdx - 1)];
  else
    lcost_sh_prev = lcost_sh_curr_L;
  barrier(0x01);

  ushort2 v_cost0_L = lcost_sh_curr_L;
  ushort2 v_cost0_H = lcost_sh_curr_H;
  ushort2 v_cost1_L = (ushort2)(lcost_sh_curr_L.y, lcost_sh_prev.x);
  ushort2 v_cost1_H = (ushort2)(lcost_sh_curr_H.y, lcost_sh_curr_L.x);

  ushort2 v_cost2_L = (ushort2)(lcost_sh_curr_H.y, lcost_sh_curr_L.x);
  ushort2 v_cost2_H = (ushort2)(lcost_sh_next.y, lcost_sh_curr_H.x);

  ushort2 v_minCost = (ushort2)(minCost, minCost);

  ushort2 v_cost3 = v_minCost + (ushort2)(100, 100);

  v_cost1_L = v_cost1_L + (ushort2)(20);
  v_cost2_L = v_cost2_L + (ushort2)(20);

  v_cost1_H = v_cost1_H + (ushort2)(20);
  v_cost2_H = v_cost2_H + (ushort2)(20);

  ushort2 v_tmp_a_L = min(v_cost0_L, v_cost1_L);
  ushort2 v_tmp_a_H = min(v_cost0_H, v_cost1_H);

  ushort2 v_tmp_b_L = min(v_cost2_L, v_cost3);
  ushort2 v_tmp_b_H = min(v_cost2_H, v_cost3);

  ushort2 cost_tmp_L = v_diff_L + min(v_tmp_a_L, v_tmp_b_L) - v_minCost;
  ushort2 cost_tmp_H = v_diff_H + min(v_tmp_a_H, v_tmp_b_H) - v_minCost;

  d_scost[hook(1, 128 * idx + k * 4 + 0)] += cost_tmp_L.y;
  d_scost[hook(1, 128 * idx + k * 4 + 1)] += cost_tmp_L.x;
  d_scost[hook(1, 128 * idx + k * 4 + 2)] += cost_tmp_H.y;
  d_scost[hook(1, 128 * idx + k * 4 + 3)] += cost_tmp_H.x;
  lcost_sh[hook(7, shIdx + 0)] = cost_tmp_L;
  lcost_sh[hook(7, shIdx + 1)] = cost_tmp_H;

  ushort2 cost_tmp = min(cost_tmp_L, cost_tmp_H);

  minCostNext[hook(5, get_local_id(1) * 32 + get_local_id(0))] = min(cost_tmp.x, cost_tmp.y);

  return min_warp(minCostNext);
}

kernel void compute_stereo_horizontal_dir_kernel_4(global const uchar4* d_matching_cost, global ushort* d_scost, int width, int height) {
  local ushort2 lcost_sh[128 * 8 / 2];
  local ushort minCostNext[32 * 8];

  init_lcost_sh_128(lcost_sh);
  int i = get_group_id(0) * 8 + get_local_id(1);
  int minCost = 0;

  for (int j = 0; j < width; j++) {
    minCost = stereo_loop_128(get_idx_y_4(height, i), get_idx_x_4(width, j), d_matching_cost, d_scost, width, height, minCost, lcost_sh, minCostNext);

    barrier(0x01);
  }
}