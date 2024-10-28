//{"buffer":6,"filters":4,"height":3,"in":0,"ip":10,"lookup":5,"lookup[y % size]":9,"o":12,"out":1,"sum":11,"width":2,"xtrans":8,"xtrans[row % 6]":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampleri = 0 | 2 | 0x10;
constant sampler_t samplerf = 0 | 2 | 0x20;
constant sampler_t samplerc = 0 | 4 | 0x10;
int FC(const int row, const int col, const unsigned int filters) {
  return filters >> ((((row) << 1 & 14) + ((col)&1)) << 1) & 3;
}

int FCxtrans(const int row, const int col, global const unsigned char (*const xtrans)[6]) {
  return xtrans[hook(8, row % 6)][hook(7, col % 6)];
}

int fcol(const int row, const int col, const unsigned int filters, global const unsigned char (*const xtrans)[6]) {
  if (filters == 9)

    return FCxtrans(row + 6, col + 6, xtrans);
  else
    return FC(row, col, filters);
}

kernel void vng_lin_interpolate(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const unsigned int filters, global const int (*const lookup)[16][32], local float* buffer) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int xlsz = get_local_size(0);
  const int ylsz = get_local_size(1);
  const int xlid = get_local_id(0);
  const int ylid = get_local_id(1);
  const int xgid = get_group_id(0);
  const int ygid = get_group_id(1);

  const int l = mad24(ylid, xlsz, xlid);
  const int lsz = mul24(xlsz, ylsz);

  const int stride = xlsz + 2;
  const int maxbuf = mul24(stride, ylsz + 2);

  const int xul = mul24(xgid, xlsz) - 1;
  const int yul = mul24(ygid, ylsz) - 1;

  for (int n = 0; n <= maxbuf / lsz; n++) {
    const int bufidx = mad24(n, lsz, l);
    if (bufidx >= maxbuf)
      continue;
    const int xx = xul + bufidx % stride;
    const int yy = yul + bufidx / stride;
    buffer[hook(6, bufidx)] = read_imagef(in, sampleri, (int2)(xx, yy)).x;
  }

  buffer += mad24(ylid + 1, stride, xlid + 1);

  barrier(0x01);

  if (x < 1 || x >= width - 1 || y < 1 || y >= height - 1)
    return;

  const int colors = (filters == 9) ? 3 : 4;
  const int size = (filters == 9) ? 6 : 16;

  float sum[4] = {0.0f};
  float o[4] = {0.0f};

  global const int* ip = lookup[hook(5, y % size)][hook(9, x % size)];
  int num_pixels = ip[hook(10, 0)];
  ip++;

  for (int i = 0; i < num_pixels; i++, ip += 3) {
    const int offset = ip[hook(10, 0)];
    const int xx = (short)(offset & 0xffffu);
    const int yy = (short)(offset >> 16);
    const int idx = mad24(yy, stride, xx);
    sum[hook(11, ip[2hook(10, 2))] += buffer[hook(6, idx)] * ip[hook(10, 1)];
  }

  for (int i = 0; i < colors - 1; i++, ip += 2) {
    o[hook(12, ip[0hook(10, 0))] = sum[hook(11, ip[0hook(10, 0))] / ip[hook(10, 1)];
  }

  o[hook(12, ip[0hook(10, 0))] = buffer[hook(6, 0)];

  write_imagef(out, (int2)(x, y), (float4)(o[hook(12, 0)], o[hook(12, 1)], o[hook(12, 2)], o[hook(12, 3)]));
}