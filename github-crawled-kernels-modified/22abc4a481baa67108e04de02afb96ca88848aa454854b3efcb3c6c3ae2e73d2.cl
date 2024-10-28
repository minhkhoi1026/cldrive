//{"d_cost":2,"d_matching_cost":8,"d_scost":10,"height":4,"lcost_sh":9,"leftDisp":0,"minCostNext":6,"rightDisp":1,"sh":5,"tmp_costs":11,"valL1":12,"values":7,"width":3}
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
  sh[hook(5, 128 * get_local_id(1) / 2 + get_local_id(0) * 2 + 0)] = (ushort2)(0);
  sh[hook(5, 128 * get_local_id(1) / 2 + get_local_id(0) * 2 + 1)] = (ushort2)(0);
  barrier(0x01);
}

inline int min_warp(local ushort* minCostNext) {
  int local_index = get_local_id(0) + get_local_id(1) * 32;
  barrier(0x01);
  for (int offset = 32 / 2; offset > 0; offset = offset / 2) {
    if (get_local_id(0) < offset) {
      ushort other = minCostNext[hook(6, local_index + offset)];
      ushort mine = minCostNext[hook(6, local_index)];
      minCostNext[hook(6, local_index)] = (mine < other) ? mine : other;
    }
    barrier(0x01);
  }

  return minCostNext[hook(6, get_local_id(1) * 32)];
}

inline int min_warp_int(local int* values) {
  int local_index = get_local_id(0) + get_local_id(1) * 32;
  barrier(0x01);
  for (int offset = 32 / 2; offset > 0; offset = offset / 2) {
    if (get_local_id(0) < offset) {
      int other = values[hook(7, local_index + offset)];
      int mine = values[hook(7, local_index)];
      values[hook(7, local_index)] = (mine < other) ? mine : other;
    }
    barrier(0x01);
  }

  return values[hook(7, get_local_id(1) * 32)];
}

inline int stereo_loop_128(int i, int j, global const uchar4* d_matching_cost, global ushort* d_scost, int width, int height, int minCost, local ushort2* lcost_sh, local ushort* minCostNext) {
  int idx = i * width + j;
  int k = get_local_id(0);
  int shIdx = 128 * get_local_id(1) / 2 + 2 * k;

  uchar4 diff_tmp = d_matching_cost[hook(8, idx * 128 / 4 + k)];

  ushort2 v_diff_L = (ushort2)(diff_tmp.y, diff_tmp.x);
  ushort2 v_diff_H = (ushort2)(diff_tmp.w, diff_tmp.z);

  ushort2 lcost_sh_curr_L = lcost_sh[hook(9, shIdx + 0)];
  ushort2 lcost_sh_curr_H = lcost_sh[hook(9, shIdx + 1)];
  ushort2 lcost_sh_prev, lcost_sh_next;

  if (shIdx + 2 < 128 * 8 / 2)
    lcost_sh_next = lcost_sh[hook(9, shIdx + 2)];
  else
    lcost_sh_next = lcost_sh_curr_H;

  if (shIdx - 1 > 0)
    lcost_sh_prev = lcost_sh[hook(9, shIdx - 1)];
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

  d_scost[hook(10, 128 * idx + k * 4 + 0)] += cost_tmp_L.y;
  d_scost[hook(10, 128 * idx + k * 4 + 1)] += cost_tmp_L.x;
  d_scost[hook(10, 128 * idx + k * 4 + 2)] += cost_tmp_H.y;
  d_scost[hook(10, 128 * idx + k * 4 + 3)] += cost_tmp_H.x;
  lcost_sh[hook(9, shIdx + 0)] = cost_tmp_L;
  lcost_sh[hook(9, shIdx + 1)] = cost_tmp_H;

  ushort2 cost_tmp = min(cost_tmp_L, cost_tmp_H);

  minCostNext[hook(6, get_local_id(1) * 32 + get_local_id(0))] = min(cost_tmp.x, cost_tmp.y);

  return min_warp(minCostNext);
}

int get_idx_x_1(int width, int j) {
  return j;
}
int get_idx_y_1(int height, int i) {
  return i;
}
int get_idx_x_3(int width, int j) {
  return width - 1 - j;
}
int get_idx_y_3(int height, int i) {
  return i;
}
int get_idx_x_5(int width, int j) {
  return width - 1 - j;
}
int get_idx_y_5(int height, int i) {
  return height - 1 - i;
}
int get_idx_x_7(int width, int j) {
  return j;
}
int get_idx_y_7(int height, int i) {
  return height - 1 - i;
}

kernel void winner_takes_all_kernel128(global ushort* leftDisp, global ushort* rightDisp, global const ushort* d_cost, int width, int height) {
  const float uniqueness = 0.95f;

  int idx = get_local_id(0);
  int x = get_group_id(0) * 8 + get_local_id(1);
  int y = get_group_id(1);

  const unsigned cost_offset = 128 * (y * width + x);
  global const ushort* current_cost = d_cost + cost_offset;

  local ushort tmp_costs_block[128 * 8];
  local ushort* tmp_costs = tmp_costs_block + 128 * get_local_id(1);

  unsigned int tmp_cL1, tmp_cL2;
  unsigned int tmp_cL3, tmp_cL4;
  unsigned int tmp_cR1, tmp_cR2;
  unsigned int tmp_cR3, tmp_cR4;

  const int idx_1 = idx * 4 + 0;
  const int idx_2 = idx * 4 + 1;
  const int idx_3 = idx * 4 + 2;
  const int idx_4 = idx * 4 + 3;

  tmp_costs[hook(11, idx_1)] = ((x + (idx_1)) >= width) ? 0xffff : d_cost[hook(2, 128 * (y * width + (x + idx_1)) + idx_1)];
  tmp_costs[hook(11, idx_2)] = ((x + (idx_2)) >= width) ? 0xffff : d_cost[hook(2, 128 * (y * width + (x + idx_2)) + idx_2)];
  tmp_costs[hook(11, idx_3)] = ((x + (idx_3)) >= width) ? 0xffff : d_cost[hook(2, 128 * (y * width + (x + idx_3)) + idx_3)];
  tmp_costs[hook(11, idx_4)] = ((x + (idx_4)) >= width) ? 0xffff : d_cost[hook(2, 128 * (y * width + (x + idx_4)) + idx_4)];

  ushort4 tmp_vcL1 = vload4(0, current_cost + idx_1);

  tmp_cR1 = tmp_costs[hook(11, idx_1)];
  tmp_cR2 = tmp_costs[hook(11, idx_2)];
  tmp_cR3 = tmp_costs[hook(11, idx_3)];
  tmp_cR4 = tmp_costs[hook(11, idx_4)];

  tmp_cL1 = (tmp_vcL1.x << 16) + idx_1;
  tmp_cL2 = (tmp_vcL1.y << 16) + idx_2;
  tmp_cL3 = (tmp_vcL1.z << 16) + idx_3;
  tmp_cL4 = (tmp_vcL1.w << 16) + idx_4;

  tmp_cR1 = (tmp_cR1 << 16) + idx_1;
  tmp_cR2 = (tmp_cR2 << 16) + idx_2;
  tmp_cR3 = (tmp_cR3 << 16) + idx_3;
  tmp_cR4 = (tmp_cR4 << 16) + idx_4;

  local int valL1[32 * 8];

  valL1[hook(12, idx + get_local_id(1) * 32)] = min(min(tmp_cL1, tmp_cL2), min(tmp_cL3, tmp_cL4));
  int minTempL1 = min_warp_int(valL1);

  int minCostL1 = (minTempL1 >> 16);
  int minDispL1 = minTempL1 & 0xffff;

  if (idx_1 == minDispL1) {
    tmp_cL1 = 0x7fffffff;
  }
  if (idx_2 == minDispL1) {
    tmp_cL2 = 0x7fffffff;
  }
  if (idx_3 == minDispL1) {
    tmp_cL3 = 0x7fffffff;
  }
  if (idx_4 == minDispL1) {
    tmp_cL4 = 0x7fffffff;
  }

  valL1[hook(12, idx + get_local_id(1) * 32)] = min(min(tmp_cL1, tmp_cL2), min(tmp_cL3, tmp_cL4));
  int minTempL2 = min_warp_int(valL1);
  int minCostL2 = (minTempL2 >> 16);
  int minDispL2 = minTempL2 & 0xffff;
  minDispL2 = minDispL2 == 0xffff ? -1 : minDispL2;

  if (idx_1 + x >= width) {
    tmp_cR1 = 0x7fffffff;
  }
  if (idx_2 + x >= width) {
    tmp_cR2 = 0x7fffffff;
  }
  if (idx_3 + x >= width) {
    tmp_cR3 = 0x7fffffff;
  }
  if (idx_4 + x >= width) {
    tmp_cR4 = 0x7fffffff;
  }

  valL1[hook(12, idx + get_local_id(1) * 32)] = min(min(tmp_cR1, tmp_cR2), min(tmp_cR3, tmp_cR4));
  int minTempR1 = min_warp_int(valL1);

  int minCostR1 = (minTempR1 >> 16);
  int minDispR1 = minTempR1 & 0xffff;
  if (minDispR1 == 0xffff) {
    minDispR1 = -1;
  }

  tmp_costs[hook(11, idx_1)] = ((idx_1) == minDispR1 || (x + (idx_1)) >= width) ? 0xffff : tmp_costs[hook(11, idx_1)];
  tmp_costs[hook(11, idx_2)] = ((idx_2) == minDispR1 || (x + (idx_2)) >= width) ? 0xffff : tmp_costs[hook(11, idx_2)];
  tmp_costs[hook(11, idx_3)] = ((idx_3) == minDispR1 || (x + (idx_3)) >= width) ? 0xffff : tmp_costs[hook(11, idx_3)];
  tmp_costs[hook(11, idx_4)] = ((idx_4) == minDispR1 || (x + (idx_4)) >= width) ? 0xffff : tmp_costs[hook(11, idx_4)];

  tmp_cR1 = tmp_costs[hook(11, idx_1)];
  tmp_cR1 = (tmp_cR1 << 16) + idx_1;

  tmp_cR2 = tmp_costs[hook(11, idx_2)];
  tmp_cR2 = (tmp_cR2 << 16) + idx_2;

  tmp_cR3 = tmp_costs[hook(11, idx_3)];
  tmp_cR3 = (tmp_cR3 << 16) + idx_3;

  tmp_cR4 = tmp_costs[hook(11, idx_4)];
  tmp_cR4 = (tmp_cR4 << 16) + idx_4;

  if (idx_1 + x >= width || idx_1 == minDispR1) {
    tmp_cR1 = 0x7fffffff;
  }
  if (idx_2 + x >= width || idx_2 == minDispR1) {
    tmp_cR2 = 0x7fffffff;
  }
  if (idx_3 + x >= width || idx_3 == minDispR1) {
    tmp_cR3 = 0x7fffffff;
  }
  if (idx_4 + x >= width || idx_4 == minDispR1) {
    tmp_cR4 = 0x7fffffff;
  }

  valL1[hook(12, idx + get_local_id(1) * 32)] = min(min(tmp_cR1, tmp_cR2), min(tmp_cR3, tmp_cR4));
  int minTempR2 = min_warp_int(valL1);
  int minCostR2 = (minTempR2 >> 16);
  int minDispR2 = minTempR2 & 0xffff;
  if (minDispR2 == 0xffff) {
    minDispR2 = -1;
  }

  if (idx == 0) {
    float lhv = minCostL2 * uniqueness;
    leftDisp[hook(0, y * width + x)] = (lhv < minCostL1 && abs(minDispL1 - minDispL2) > 1) ? 0 : minDispL1 + 1;
    float rhv = minCostR2 * uniqueness;
    rightDisp[hook(1, y * width + x)] = (rhv < minCostR1 && abs(minDispR1 - minDispR2) > 1) ? 0 : minDispR1 + 1;
  }
}