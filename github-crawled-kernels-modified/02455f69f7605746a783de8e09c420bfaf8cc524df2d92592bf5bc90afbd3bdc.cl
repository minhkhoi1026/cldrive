//{"histogram":8,"in":0,"in4":9,"isums":1,"l_block_counts":6,"l_scanned_seeds":7,"lmem":4,"n":3,"out":2,"shift":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int scanLocalMem(unsigned int val, local unsigned int* lmem, int exclusive) {
  int idx = get_local_id(0);
  lmem[hook(4, idx)] = 0;

  idx += get_local_size(0);
  lmem[hook(4, idx)] = val;
  barrier(0x01);

  unsigned int t;
  for (int i = 1; i < get_local_size(0); i *= 2) {
    t = lmem[hook(4, idx - i)];
    barrier(0x01);
    lmem[hook(4, idx)] += t;
    barrier(0x01);
  }
  return lmem[hook(4, idx - exclusive)];
}

kernel void bottom_scan(global const unsigned int* in, global const unsigned int* isums, global unsigned int* out, const int n, local unsigned int* lmem, const int shift) {
  local unsigned int l_scanned_seeds[16];

  local unsigned int l_block_counts[16];

 private
  int histogram[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

  global uint4* in4 = (global uint4*)in;
  global uint4* out4 = (global uint4*)out;
  int n4 = n / 4;

  int region_size = n4 / get_num_groups(0);
  int block_start = get_group_id(0) * region_size;

  int block_stop = (get_group_id(0) == get_num_groups(0) - 1) ? n4 : block_start + region_size;

  int i = block_start + get_local_id(0);
  int window = block_start;

  if (get_local_id(0) < 16) {
    l_block_counts[hook(6, get_local_id(0))] = 0;
    l_scanned_seeds[hook(7, get_local_id(0))] = isums[hook(1, (get_local_id(0) * get_num_groups(0)) + get_group_id(0))];
  }
  barrier(0x01);

  while (window < block_stop) {
    for (int q = 0; q < 16; q++)
      histogram[hook(8, q)] = 0;
    uint4 val_4;
    uint4 key_4;

    if (i < block_stop) {
      val_4 = in4[hook(9, i)];

      key_4.x = (val_4.x >> shift) & 0xFU;
      key_4.y = (val_4.y >> shift) & 0xFU;
      key_4.z = (val_4.z >> shift) & 0xFU;
      key_4.w = (val_4.w >> shift) & 0xFU;

      histogram[hook(8, key_4.x)]++;
      histogram[hook(8, key_4.y)]++;
      histogram[hook(8, key_4.z)]++;
      histogram[hook(8, key_4.w)]++;
    }

    for (int digit = 0; digit < 16; digit++) {
      histogram[hook(8, digit)] = scanLocalMem(histogram[hook(8, digit)], lmem, 1);
      barrier(0x01);
    }

    if (i < block_stop) {
      int address;
      address = histogram[hook(8, key_4.x)] + l_scanned_seeds[hook(7, key_4.x)] + l_block_counts[hook(6, key_4.x)];
      out[hook(2, address)] = val_4.x;
      histogram[hook(8, key_4.x)]++;

      address = histogram[hook(8, key_4.y)] + l_scanned_seeds[hook(7, key_4.y)] + l_block_counts[hook(6, key_4.y)];
      out[hook(2, address)] = val_4.y;
      histogram[hook(8, key_4.y)]++;

      address = histogram[hook(8, key_4.z)] + l_scanned_seeds[hook(7, key_4.z)] + l_block_counts[hook(6, key_4.z)];
      out[hook(2, address)] = val_4.z;
      histogram[hook(8, key_4.z)]++;

      address = histogram[hook(8, key_4.w)] + l_scanned_seeds[hook(7, key_4.w)] + l_block_counts[hook(6, key_4.w)];
      out[hook(2, address)] = val_4.w;
      histogram[hook(8, key_4.w)]++;
    }

    barrier(0x01);

    if (get_local_id(0) == get_local_size(0) - 1) {
      for (int q = 0; q < 16; q++) {
        l_block_counts[hook(6, q)] += histogram[hook(8, q)];
      }
    }
    barrier(0x01);

    window += get_local_size(0);
    i += get_local_size(0);
  }
}