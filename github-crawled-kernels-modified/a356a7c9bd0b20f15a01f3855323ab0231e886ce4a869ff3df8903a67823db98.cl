//{"start":2,"x":0,"x_shared":4,"x_shared[get_local_id(1)]":3,"x_unroll":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void unroll2(global float* x, global float* x_unroll, const unsigned int start) {
  const unsigned int x_unroll_height = (5 * 5);

  const unsigned int x_unroll_width = ((((28 - 5 + 1) / 2) - 5 + 1) * (((28 - 5 + 1) / 2) - 5 + 1));

  const unsigned int channel_idx = start + get_group_id(0) * get_local_size(1) + get_local_id(1);

  const unsigned int address_per_channel = x_unroll_height * x_unroll_width;

  local float x_shared[(512 / ((((28 - 5 + 1) / 2) - 5 + 1) * (((28 - 5 + 1) / 2) - 5 + 1)))][(((28 - 5 + 1) / 2) * ((28 - 5 + 1) / 2))];
  const unsigned int x_base = channel_idx * (((28 - 5 + 1) / 2) * ((28 - 5 + 1) / 2));
  for (unsigned int i = get_local_id(0); i < (((28 - 5 + 1) / 2) * ((28 - 5 + 1) / 2)); i += get_local_size(0)) {
    x_shared[hook(4, get_local_id(1))][hook(3, i)] = x[hook(0, x_base + i)];
  }
  barrier(0x01);

  const unsigned int t = get_local_id(0);

  const unsigned int x_row_base = t / (((28 - 5 + 1) / 2) - 5 + 1);

  const unsigned int x_col_base = t % (((28 - 5 + 1) / 2) - 5 + 1);

  unsigned int x_unroll_offset = channel_idx * address_per_channel + t;

  for (unsigned int i = 0; i < 5; i++) {
    const unsigned int x_start = (x_row_base + i) * ((28 - 5 + 1) / 2);
    for (unsigned int j = 0; j < 5; j++) {
      x_unroll[hook(1, x_unroll_offset)] = x_shared[hook(4, get_local_id(1))][hook(3, x_start + (x_col_base + j))];
      x_unroll_offset += x_unroll_width;
    }
  }
}