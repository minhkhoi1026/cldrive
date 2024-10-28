//{"dir":5,"in_data":0,"l_data":2,"out_data":1,"points_per_group":3,"size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fft_init(global float2* in_data, global float2* out_data, local float2* l_data, unsigned int points_per_group, unsigned int size, int dir) {
  uint4 br, index;
  unsigned int points_per_item, g_addr, l_addr, i, fft_index, stage, N2;
  float2 x1, x2, x3, x4, sum12, diff12, sum34, diff34;

  points_per_item = points_per_group / get_local_size(0);
  l_addr = get_local_id(0) * points_per_item;
  g_addr = get_group_id(0) * points_per_group + l_addr;

  for (i = 0; i < points_per_item; i += 4) {
    index = (uint4)(g_addr, g_addr + 1, g_addr + 2, g_addr + 3);
    fft_index = size / 2;
    stage = 1;
    N2 = (unsigned int)log2((float)size) - 1;
    br = (index << N2) & fft_index;
    br |= (index >> N2) & stage;

    while (N2 > 1) {
      N2 -= 2;
      fft_index >>= 1;
      stage <<= 1;
      br |= (index << N2) & fft_index;
      br |= (index >> N2) & stage;
    }

    x1 = in_data[hook(0, br.s0)];
    x2 = in_data[hook(0, br.s1)];
    x3 = in_data[hook(0, br.s2)];
    x4 = in_data[hook(0, br.s3)];

    sum12 = x1 + x2;
    diff12 = x1 - x2;
    sum34 = x3 + x4;
    diff34 = (float2)(x3.s1 - x4.s1, x4.s0 - x3.s0) * dir;
    l_data[hook(2, l_addr)] = sum12 + sum34;
    l_data[hook(2, l_addr + 1)] = diff12 + diff34;
    l_data[hook(2, l_addr + 2)] = sum12 - sum34;
    l_data[hook(2, l_addr + 3)] = diff12 - diff34;
    l_addr += 4;
    g_addr += 4;
  }

  for (N2 = 4; N2 < points_per_item; N2 <<= 1) {
    l_addr = get_local_id(0) * points_per_item;
    for (fft_index = 0; fft_index < points_per_item; fft_index += 2 * N2) {
      x1 = l_data[hook(2, l_addr)];
      l_data[hook(2, l_addr)] += l_data[hook(2, l_addr + N2)];
      l_data[hook(2, l_addr + N2)] = x1 - l_data[hook(2, l_addr + N2)];
      for (i = 1; i < N2; i++) {
        x3.s0 = cos(3.14159265358979323846264338327950288f * i / N2);
        x3.s1 = dir * sin(3.14159265358979323846264338327950288f * i / N2);
        x2 = (float2)(l_data[hook(2, l_addr + N2 + i)].s0 * x3.s0 + l_data[hook(2, l_addr + N2 + i)].s1 * x3.s1, l_data[hook(2, l_addr + N2 + i)].s1 * x3.s0 - l_data[hook(2, l_addr + N2 + i)].s0 * x3.s1);
        l_data[hook(2, l_addr + N2 + i)] = l_data[hook(2, l_addr + i)] - x2;
        l_data[hook(2, l_addr + i)] += x2;
      }
      l_addr += 2 * N2;
    }
  }
  barrier(0x01);

  stage = 2;
  for (N2 = points_per_item; N2 < points_per_group; N2 <<= 1) {
    br.s0 = (get_local_id(0) + (get_local_id(0) / stage) * stage) * (points_per_item / 2);
    size = br.s0 % (N2 * 2);
    for (i = br.s0; i < br.s0 + points_per_item / 2; i++) {
      x3.s0 = cos(3.14159265358979323846264338327950288f * size / N2);
      x3.s1 = dir * sin(3.14159265358979323846264338327950288f * size / N2);
      x2 = (float2)(l_data[hook(2, N2 + i)].s0 * x3.s0 + l_data[hook(2, N2 + i)].s1 * x3.s1, l_data[hook(2, N2 + i)].s1 * x3.s0 - l_data[hook(2, N2 + i)].s0 * x3.s1);
      l_data[hook(2, N2 + i)] = l_data[hook(2, i)] - x2;
      l_data[hook(2, i)] += x2;
      size++;
    }
    stage <<= 1;
    barrier(0x01);
  }

  l_addr = get_local_id(0) * points_per_item;
  g_addr = get_group_id(0) * points_per_group + l_addr;
  for (i = 0; i < points_per_item; i += 4) {
    out_data[hook(1, g_addr)] = l_data[hook(2, l_addr)];
    out_data[hook(1, g_addr + 1)] = l_data[hook(2, l_addr + 1)];
    out_data[hook(1, g_addr + 2)] = l_data[hook(2, l_addr + 2)];
    out_data[hook(1, g_addr + 3)] = l_data[hook(2, l_addr + 3)];
    g_addr += 4;
    l_addr += 4;
  }
}