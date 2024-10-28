//{"buffer":6,"filters":4,"height":3,"in":0,"lim":9,"med":10,"out":1,"threshold":5,"width":2,"xtrans":8,"xtrans[row % 6]":7}
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
int2 backtransformi(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (int2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

float2 backtransformf(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (float2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

constant int glim[5] = {0, 1, 2, 1, 0};

kernel void pre_median(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const unsigned int filters, const float threshold, local float* buffer) {
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
    buffer[hook(6, bufidx)] = read_imagef(in, sampleri, (int2)(xx, yy)).x;
  }

  buffer += mad24(ylid + 2, stride, xlid + 2);

  barrier(0x01);

  if (x >= width || y >= height)
    return;

  constant int* lim = glim;

  const int c = FC(y, x, filters);

  float med[9];

  int cnt = 0;

  for (int k = 0, i = 0; i < 5; i++) {
    for (int j = -lim[hook(9, i)]; j <= lim[hook(9, i)]; j += 2) {
      if (fabs(buffer[hook(6, stride * (i - 2) + j)] - buffer[hook(6, 0)]) < threshold) {
        med[hook(10, k++)] = buffer[hook(6, stride * (i - 2) + j)];
        cnt++;
      } else
        med[hook(10, k++)] = 64.0f + buffer[hook(6, stride * (i - 2) + j)];
    }
  }

  for (int i = 0; i < 8; i++)
    for (int ii = i + 1; ii < 9; ii++)
      if (med[hook(10, i)] > med[hook(10, ii)]) {
        const float tmp = (med[hook(10, ii)]);
        (med[hook(10, ii)]) = (med[hook(10, i)]);
        (med[hook(10, i)]) = tmp;
      };

  float float3 = (c & 1) ? (cnt == 1 ? med[hook(10, 4)] - 64.0f : med[hook(10, (cnt - 1) / 2)]) : buffer[hook(6, 0)];

  write_imagef(out, (int2)(x, y), float3);
}