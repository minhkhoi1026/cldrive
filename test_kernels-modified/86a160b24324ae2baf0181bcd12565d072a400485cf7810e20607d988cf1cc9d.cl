//{"a":9,"a_d":0,"b":10,"b_d":1,"c":11,"c_d":2,"d":12,"d_d":3,"iterations":8,"num_systems":7,"shared":5,"system_size":6,"x":13,"x_d":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pcr_branch_free_kernel(global float* a_d, global float* b_d, global float* c_d, global float* d_d, global float* x_d, local float* shared, int system_size, int num_systems, int iterations) {
  int thid = get_local_id(0);
  int blid = get_group_id(0);

  int delta = 1;

  local float* a = shared;
  local float* b = &a[hook(9, system_size + 1)];
  local float* c = &b[hook(10, system_size + 1)];
  local float* d = &c[hook(11, system_size + 1)];
  local float* x = &d[hook(12, system_size + 1)];

  a[hook(9, thid)] = a_d[hook(0, thid + blid * system_size)];
  b[hook(10, thid)] = b_d[hook(1, thid + blid * system_size)];
  c[hook(11, thid)] = c_d[hook(2, thid + blid * system_size)];
  d[hook(12, thid)] = d_d[hook(3, thid + blid * system_size)];

  float aNew, bNew, cNew, dNew;

  barrier(0x01);

  for (int j = 0; j < iterations; j++) {
    int i = thid;

    int iRight = i + delta;
    iRight = iRight & (system_size - 1);

    int iLeft = i - delta;
    iLeft = iLeft & (system_size - 1);

    float tmp1 = native_divide(a[hook(9, i)], b[hook(10, iLeft)]);
    float tmp2 = native_divide(c[hook(11, i)], b[hook(10, iRight)]);

    bNew = b[hook(10, i)] - c[hook(11, iLeft)] * tmp1 - a[hook(9, iRight)] * tmp2;
    dNew = d[hook(12, i)] - d[hook(12, iLeft)] * tmp1 - d[hook(12, iRight)] * tmp2;
    aNew = -a[hook(9, iLeft)] * tmp1;
    cNew = -c[hook(11, iRight)] * tmp2;

    barrier(0x01);

    b[hook(10, i)] = bNew;
    d[hook(12, i)] = dNew;
    a[hook(9, i)] = aNew;
    c[hook(11, i)] = cNew;

    delta *= 2;
    barrier(0x01);
  }

  if (thid < delta) {
    int addr1 = thid;
    int addr2 = thid + delta;
    float tmp3 = b[hook(10, addr2)] * b[hook(10, addr1)] - c[hook(11, addr1)] * a[hook(9, addr2)];

    x[hook(13, addr1)] = native_divide((b[hook(10, addr2)] * d[hook(12, addr1)] - c[hook(11, addr1)] * d[hook(12, addr2)]), tmp3);
    x[hook(13, addr2)] = native_divide((d[hook(12, addr2)] * b[hook(10, addr1)] - d[hook(12, addr1)] * a[hook(9, addr2)]), tmp3);
  }

  barrier(0x01);

  x_d[hook(4, thid + blid * system_size)] = x[hook(13, thid)];
}