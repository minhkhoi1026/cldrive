//{"in":0,"in4":5,"isums":1,"lmem":4,"n":3,"out":2,"out4":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float scanLocalMem(float val, local float* lmem, int exclusive) {
  int idx = get_local_id(0);
  lmem[hook(4, idx)] = 0.0f;

  idx += get_local_size(0);
  lmem[hook(4, idx)] = val;
  barrier(0x01);

  float t;
  for (int i = 1; i < get_local_size(0); i *= 2) {
    t = lmem[hook(4, idx - i)];
    barrier(0x01);
    lmem[hook(4, idx)] += t;
    barrier(0x01);
  }
  return lmem[hook(4, idx - exclusive)];
}

kernel void bottom_scan(global const float* in, global const float* isums, global float* out, const int n, local float* lmem) {
  local float s_seed;
  s_seed = 0;

  global float4* in4 = (global float4*)in;
  global float4* out4 = (global float4*)out;
  int n4 = n / 4;

  int region_size = n4 / get_num_groups(0);
  int block_start = get_group_id(0) * region_size;

  int block_stop = (get_group_id(0) == get_num_groups(0) - 1) ? n4 : block_start + region_size;

  int i = block_start + get_local_id(0);
  unsigned int window = block_start;

  float seed = isums[hook(1, get_group_id(0))];

  while (window < block_stop) {
    float4 val_4;
    if (i < block_stop) {
      val_4 = in4[hook(5, i)];
    } else {
      val_4.x = 0.0f;
      val_4.y = 0.0f;
      val_4.z = 0.0f;
      val_4.w = 0.0f;
    }

    val_4.y += val_4.x;
    val_4.z += val_4.y;
    val_4.w += val_4.z;

    float res = scanLocalMem(val_4.w, lmem, 1);

    val_4.x += res + seed;
    val_4.y += res + seed;
    val_4.z += res + seed;
    val_4.w += res + seed;

    if (i < block_stop) {
      out4[hook(6, i)] = val_4;
    }

    barrier(0x01);
    if (get_local_id(0) == get_local_size(0) - 1) {
      s_seed = val_4.w;
    }
    barrier(0x01);

    seed = s_seed;

    window += get_local_size(0);
    i += get_local_size(0);
  }
}