//{"((__local unsigned int *)smem)":11,"((__local unsigned int *)src)":13,"dst":12,"global_histo":7,"global_overflow":8,"global_subhisto":6,"histo_height":4,"histo_width":5,"num_elements":1,"sm_mappings":0,"sm_range_max":3,"sm_range_min":2,"smem":10,"smem[indexhi]":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void testIncrementGlobal(global unsigned int* global_histo, unsigned int sm_range_min, unsigned int sm_range_max, const uchar4 sm) {
  const unsigned int range = sm.x;
  const unsigned int indexhi = sm.y;
  const unsigned int indexlo = sm.z;
  const unsigned int offset = sm.w;

  if (range < sm_range_min || range > sm_range_max) {
    const unsigned int bin = range * 8 + offset / 8 + (indexlo << 2) + (indexhi << 10);
    const unsigned int bin_div2 = bin / 2;
    const unsigned int bin_offset = (bin % 2 == 1) ? 16 : 0;

    unsigned int old_val = global_histo[hook(7, bin_div2)];
    unsigned short old_bin = (old_val >> bin_offset) & 0xFFFF;

    if (old_bin < 255) {
      atom_add(&global_histo[hook(7, bin_div2)], 1 << bin_offset);
    }
  }
}

void testIncrementLocal(global unsigned int* global_overflow, local unsigned int smem[2][256], const unsigned int myRange, const uchar4 sm) {
  const unsigned int range = sm.x;
  const unsigned int indexhi = sm.y;
  const unsigned int indexlo = sm.z;
  const unsigned int offset = sm.w;

  if (range == myRange) {
    unsigned int add = (unsigned int)(1 << offset);
    unsigned int prev = atom_add(&smem[hook(10, indexhi)][hook(9, indexlo)], add);

    unsigned int prev_bin_val = (prev >> offset) & 0x000000FF;

    if (prev_bin_val == 0x000000FF) {
      const unsigned int bin = range * 8 + offset / 8 + (indexlo << 2) + (indexhi << 10);

      bool can_overflow_to_bin_plus_1 = (offset < 24) ? true : false;
      bool can_overflow_to_bin_plus_2 = (offset < 16) ? true : false;
      bool can_overflow_to_bin_plus_3 = (offset < 8) ? true : false;

      bool overflow_into_bin_plus_1 = false;
      bool overflow_into_bin_plus_2 = false;
      bool overflow_into_bin_plus_3 = false;

      unsigned int prev_bin_plus_1_val = (prev >> (offset + 8)) & 0x000000FF;
      unsigned int prev_bin_plus_2_val = (prev >> (offset + 16)) & 0x000000FF;
      unsigned int prev_bin_plus_3_val = (prev >> (offset + 24)) & 0x000000FF;

      if (can_overflow_to_bin_plus_1 && prev_bin_val == 0x000000FF)
        overflow_into_bin_plus_1 = true;
      if (can_overflow_to_bin_plus_2 && prev_bin_plus_1_val == 0x000000FF)
        overflow_into_bin_plus_2 = true;
      if (can_overflow_to_bin_plus_3 && prev_bin_plus_2_val == 0x000000FF)
        overflow_into_bin_plus_3 = true;

      unsigned int bin_plus_1_add;
      unsigned int bin_plus_2_add;
      unsigned int bin_plus_3_add;

      if (overflow_into_bin_plus_1)
        bin_plus_1_add = (prev_bin_plus_1_val < 0x000000FF) ? 0xFFFFFFFF : 0x000000FF;
      if (overflow_into_bin_plus_2)
        bin_plus_2_add = (prev_bin_plus_2_val < 0x000000FF) ? 0xFFFFFFFF : 0x000000FF;
      if (overflow_into_bin_plus_3)
        bin_plus_3_add = (prev_bin_plus_3_val < 0x000000FF) ? 0xFFFFFFFF : 0x000000FF;

      atom_add(&global_overflow[hook(8, bin)], 256);
      if (overflow_into_bin_plus_1)
        atom_add(&global_overflow[hook(8, bin + 1)], bin_plus_1_add);
      if (overflow_into_bin_plus_2)
        atom_add(&global_overflow[hook(8, bin + 2)], bin_plus_2_add);
      if (overflow_into_bin_plus_3)
        atom_add(&global_overflow[hook(8, bin + 3)], bin_plus_3_add);
    }
  }
}

void clearMemory(local unsigned int smem[2][256]) {
  for (int i = get_local_id(0), blockDimx = get_local_size(0); i < 8 / 4; i += blockDimx) {
    ((local unsigned int*)smem)[hook(11, i)] = 0;
  }
}

void copyMemory(global unsigned int* dst, local unsigned int src[2][256]) {
  for (int i = get_local_id(0), blockDimx = get_local_size(0); i < 8 / 4; i += blockDimx) {
    dst[hook(12, i)] = ((local unsigned int*)src)[hook(13, i)];
  }
}

kernel void histo_main_kernel(global uchar4* sm_mappings, unsigned int num_elements, unsigned int sm_range_min, unsigned int sm_range_max, unsigned int histo_height, unsigned int histo_width, global unsigned int* global_subhisto, global unsigned int* global_histo, global unsigned int* global_overflow) {
  local unsigned int sub_histo[2][256];

  unsigned int blockDimx = get_local_size(0);
  unsigned int gridDimx = get_num_groups(0);
  unsigned int local_scan_range = sm_range_min + get_group_id(1);
  unsigned int local_scan_load = get_group_id(0) * blockDimx + get_local_id(0);

  clearMemory(sub_histo);
  barrier(0x01);

  if (get_group_id(1) == 0) {
    while (local_scan_load < num_elements) {
      uchar4 sm = sm_mappings[hook(0, local_scan_load)];
      local_scan_load += blockDimx * gridDimx;

      testIncrementLocal(global_overflow, sub_histo, local_scan_range, sm);
      testIncrementGlobal(global_histo, sm_range_min, sm_range_max, sm);
    }
  } else {
    while (local_scan_load < num_elements) {
      uchar4 sm = sm_mappings[hook(0, local_scan_load)];
      local_scan_load += blockDimx * gridDimx;

      testIncrementLocal(global_overflow, sub_histo, local_scan_range, sm);
    }
  }

  unsigned int store_index = get_group_id(0) * (histo_height * histo_width / 4) + (local_scan_range * 8 / 4);

  barrier(0x01);
  copyMemory(&(global_subhisto[hook(6, store_index)]), sub_histo);
}