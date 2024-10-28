//{"buffer":8,"filters":4,"height":3,"in":0,"out":1,"r_x":5,"r_y":6,"thr":7,"width":2,"xtrans":10,"xtrans[row % 6]":9}
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
  return xtrans[hook(10, row % 6)][hook(9, col % 6)];
}
int2 backtransformi(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (int2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

float2 backtransformf(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (float2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

kernel void green_equilibration_lavg(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const unsigned int filters, const int r_x, const int r_y, const float thr, local float* buffer) {
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

  const int stride = xlsz + 2 * 2;
  const int maxbuf = mul24(stride, ylsz + 2 * 2);

  const int xul = mul24(xgid, xlsz) - 2;
  const int yul = mul24(ygid, ylsz) - 2;

  for (int n = 0; n <= maxbuf / lsz; n++) {
    const int bufidx = mad24(n, lsz, l);
    if (bufidx >= maxbuf)
      continue;
    const int xx = xul + bufidx % stride;
    const int yy = yul + bufidx / stride;
    buffer[hook(8, bufidx)] = read_imagef(in, sampleri, (int2)(xx, yy)).x;
  }

  buffer += mad24(ylid + 2, stride, xlid + 2);

  barrier(0x01);

  if (x >= width || y >= height)
    return;

  const int c = FC(y + r_y, x + r_x, filters);
  const float maximum = 1.0f;
  float o = buffer[hook(8, 0)];

  if (c == 1 && ((y + r_y) & 1)) {
    const float o1_1 = buffer[hook(8, -1 * stride - 1)];
    const float o1_2 = buffer[hook(8, -1 * stride + 1)];
    const float o1_3 = buffer[hook(8, 1 * stride - 1)];
    const float o1_4 = buffer[hook(8, 1 * stride + 1)];
    const float o2_1 = buffer[hook(8, -2 * stride + 0)];
    const float o2_2 = buffer[hook(8, 2 * stride + 0)];
    const float o2_3 = buffer[hook(8, -2)];
    const float o2_4 = buffer[hook(8, 2)];

    const float m1 = (o1_1 + o1_2 + o1_3 + o1_4) / 4.0f;
    const float m2 = (o2_1 + o2_2 + o2_3 + o2_4) / 4.0f;

    if (m2 > 0.0f && m1 / m2 < maximum * 2.0f) {
      const float c1 = (fabs(o1_1 - o1_2) + fabs(o1_1 - o1_3) + fabs(o1_1 - o1_4) + fabs(o1_2 - o1_3) + fabs(o1_3 - o1_4) + fabs(o1_2 - o1_4)) / 6.0f;
      const float c2 = (fabs(o2_1 - o2_2) + fabs(o2_1 - o2_3) + fabs(o2_1 - o2_4) + fabs(o2_2 - o2_3) + fabs(o2_3 - o2_4) + fabs(o2_2 - o2_4)) / 6.0f;

      if ((o < maximum * 0.95f) && (c1 < maximum * thr) && (c2 < maximum * thr))
        o *= m1 / m2;
    }
  }

  write_imagef(out, (int2)(x, y), o);
}