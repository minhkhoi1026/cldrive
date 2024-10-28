//{"global_index_data":0,"global_offsets":1,"global_out":4,"index_data":6,"num_vals":3,"out":7,"scratch":5,"stage":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void decode_indices(const global uchar* global_index_data, const constant unsigned int* global_offsets, const unsigned int stage, const unsigned int num_vals, global int* global_out) {
  const global uchar* const index_data = global_index_data + global_offsets[hook(1, 4 * get_global_id(1) + 3)];

  global int* const out = global_out + num_vals * get_global_id(1);
  local int scratch[128];

  const unsigned int idx_offset = (1 << (stage * 7));
  const unsigned int gidx = idx_offset * (get_global_id(0) + 1) - 1;
  const unsigned int pgidx = idx_offset * get_global_id(0) - 1;

  if (0 == stage) {
    scratch[hook(5, get_local_id(0))] = (int)(index_data[hook(6, get_global_id(0))]) - 128;
  } else if (gidx < num_vals) {
    scratch[hook(5, get_local_id(0))] = out[hook(7, gidx)];
  } else if (pgidx < num_vals) {
    scratch[hook(5, get_local_id(0))] = out[hook(7, num_vals - 1)];
  } else {
    scratch[hook(5, get_local_id(0))] = 0;
  }

  const int tid = get_local_id(0);
  unsigned int offset = 1;
  for (int i = (128 >> 1); i > 0; i = i >> 1) {
    barrier(0x01);
    if (tid < i) {
      const unsigned int a = offset * (2 * tid + 1) - 1;
      const unsigned int b = offset * (2 * tid + 2) - 1;
      scratch[hook(5, b)] += scratch[hook(5, a)];
    }

    offset *= 2;
  }

  offset >>= 1;
  for (int d = 2; d < 128; d *= 2) {
    barrier(0x01);
    offset >>= 1;
    if (offset > 0 && 0 < tid && tid < d) {
      unsigned int a = offset * (2 * tid) - 1;
      unsigned int b = offset * (2 * tid + 1) - 1;
      scratch[hook(5, b)] += scratch[hook(5, a)];
    }
  }

  barrier(0x01);
  if (0 == stage || gidx < num_vals) {
    out[hook(7, gidx)] = scratch[hook(5, get_local_id(0))];
  } else if (pgidx < num_vals && gidx >= num_vals) {
    out[hook(7, num_vals - 1)] = scratch[hook(5, get_local_id(0))];
  }
}