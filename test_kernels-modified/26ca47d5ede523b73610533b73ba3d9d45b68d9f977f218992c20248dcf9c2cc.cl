//{"a":9,"a_d":0,"b":10,"b_d":1,"c":11,"c_d":2,"d":12,"d_d":3,"iterations":8,"num_systems":7,"shared":5,"system_size":6,"x":13,"x_d":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cyclic_branch_free_kernel(global float* a_d, global float* b_d, global float* c_d, global float* d_d, global float* x_d, local float* shared, int system_size, int num_systems, int iterations) {
  int thid = get_local_id(0);
  int blid = get_group_id(0);

  int stride = 1;
  int half_size = system_size >> 1;
  int thid_num = half_size;

  local float* a = shared;
  local float* b = &a[hook(9, system_size)];
  local float* c = &b[hook(10, system_size)];
  local float* d = &c[hook(11, system_size)];
  local float* x = &d[hook(12, system_size)];

  a[hook(9, thid)] = a_d[hook(0, thid + blid * system_size)];
  a[hook(9, thid + thid_num)] = a_d[hook(0, thid + thid_num + blid * system_size)];

  b[hook(10, thid)] = b_d[hook(1, thid + blid * system_size)];
  b[hook(10, thid + thid_num)] = b_d[hook(1, thid + thid_num + blid * system_size)];

  c[hook(11, thid)] = c_d[hook(2, thid + blid * system_size)];
  c[hook(11, thid + thid_num)] = c_d[hook(2, thid + thid_num + blid * system_size)];

  d[hook(12, thid)] = d_d[hook(3, thid + blid * system_size)];
  d[hook(12, thid + thid_num)] = d_d[hook(3, thid + thid_num + blid * system_size)];

  barrier(0x01);

  for (int j = 0; j < iterations; j++) {
    barrier(0x01);

    stride <<= 1;
    int delta = stride >> 1;
    if (thid < thid_num) {
      int i = stride * thid + stride - 1;
      int iRight = i + delta;
      iRight = iRight & (system_size - 1);

      float tmp1 = native_divide(a[hook(9, i)], b[hook(10, i - delta)]);
      float tmp2 = native_divide(c[hook(11, i)], b[hook(10, iRight)]);

      b[hook(10, i)] = b[hook(10, i)] - c[hook(11, i - delta)] * tmp1 - a[hook(9, iRight)] * tmp2;
      d[hook(12, i)] = d[hook(12, i)] - d[hook(12, i - delta)] * tmp1 - d[hook(12, iRight)] * tmp2;
      a[hook(9, i)] = -a[hook(9, i - delta)] * tmp1;
      c[hook(11, i)] = -c[hook(11, iRight)] * tmp2;
    }

    thid_num >>= 1;
  }

  if (thid < 2) {
    int addr1 = stride - 1;
    int addr2 = (stride << 1) - 1;
    float tmp3 = b[hook(10, addr2)] * b[hook(10, addr1)] - c[hook(11, addr1)] * a[hook(9, addr2)];

    x[hook(13, addr1)] = native_divide((b[hook(10, addr2)] * d[hook(12, addr1)] - c[hook(11, addr1)] * d[hook(12, addr2)]), tmp3);
    x[hook(13, addr2)] = native_divide((d[hook(12, addr2)] * b[hook(10, addr1)] - d[hook(12, addr1)] * a[hook(9, addr2)]), tmp3);
  }

  thid_num = 2;
  for (int j = 0; j < iterations; j++) {
    int delta = stride >> 1;
    barrier(0x01);
    if (thid < thid_num) {
      int i = stride * thid + (stride >> 1) - 1;

      if (i == delta - 1)
        x[hook(13, i)] = native_divide((d[hook(12, i)] - c[hook(11, i)] * x[hook(13, i + delta)]), b[hook(10, i)]);
      else
        x[hook(13, i)] = native_divide((d[hook(12, i)] - a[hook(9, i)] * x[hook(13, i - delta)] - c[hook(11, i)] * x[hook(13, i + delta)]), b[hook(10, i)]);
    }
    stride >>= 1;
    thid_num <<= 1;
  }

  barrier(0x01);

  x_d[hook(4, thid + blid * system_size)] = x[hook(13, thid)];
  x_d[hook(4, thid + half_size + blid * system_size)] = x[hook(13, thid + half_size)];
}