//{"buffer":5,"filters":4,"height":3,"in":0,"out":1,"width":2,"xtrans":7,"xtrans[row % 6]":6}
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
  return xtrans[hook(7, row % 6)][hook(6, col % 6)];
}
int2 backtransformi(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (int2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

float2 backtransformf(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (float2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

constant int glim[5] = {0, 1, 2, 1, 0};

kernel void ppg_demosaic_green(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const unsigned int filters, local float* buffer) {
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

  const int stride = xlsz + 2 * 3;
  const int maxbuf = mul24(stride, ylsz + 2 * 3);

  const int xul = mul24(xgid, xlsz) - 3;
  const int yul = mul24(ygid, ylsz) - 3;

  for (int n = 0; n <= maxbuf / lsz; n++) {
    const int bufidx = mad24(n, lsz, l);
    if (bufidx >= maxbuf)
      continue;
    const int xx = xul + bufidx % stride;
    const int yy = yul + bufidx / stride;
    buffer[hook(5, bufidx)] = read_imagef(in, sampleri, (int2)(xx, yy)).x;
  }

  buffer += mad24(ylid + 3, stride, xlid + 3);

  barrier(0x01);

  if (x >= width || y >= height)
    return;

  const int row = y;
  const int col = x;
  const int c = FC(row, col, filters);
  float4 float3;

  const float pc = buffer[hook(5, 0)];

  if (c == 0)
    float3.x = pc;
  else if (c == 1)
    float3.y = pc;
  else if (c == 2)
    float3.z = pc;
  else
    float3.y = pc;

  if (c == 0 || c == 2) {
    const float pym = buffer[hook(5, -1 * stride)];
    const float pym2 = buffer[hook(5, -2 * stride)];
    const float pym3 = buffer[hook(5, -3 * stride)];
    const float pyM = buffer[hook(5, 1 * stride)];
    const float pyM2 = buffer[hook(5, 2 * stride)];
    const float pyM3 = buffer[hook(5, 3 * stride)];
    const float pxm = buffer[hook(5, -1)];
    const float pxm2 = buffer[hook(5, -2)];
    const float pxm3 = buffer[hook(5, -3)];
    const float pxM = buffer[hook(5, 1)];
    const float pxM2 = buffer[hook(5, 2)];
    const float pxM3 = buffer[hook(5, 3)];
    const float guessx = (pxm + pc + pxM) * 2.0f - pxM2 - pxm2;
    const float diffx = (fabs(pxm2 - pc) + fabs(pxM2 - pc) + fabs(pxm - pxM)) * 3.0f + (fabs(pxM3 - pxM) + fabs(pxm3 - pxm)) * 2.0f;
    const float guessy = (pym + pc + pyM) * 2.0f - pyM2 - pym2;
    const float diffy = (fabs(pym2 - pc) + fabs(pyM2 - pc) + fabs(pym - pyM)) * 3.0f + (fabs(pyM3 - pyM) + fabs(pym3 - pym)) * 2.0f;
    if (diffx > diffy) {
      const float m = fmin(pym, pyM);
      const float M = fmax(pym, pyM);
      float3.y = fmax(fmin(guessy * 0.25f, M), m);
    } else {
      const float m = fmin(pxm, pxM);
      const float M = fmax(pxm, pxM);
      float3.y = fmax(fmin(guessx * 0.25f, M), m);
    }
  }
  write_imagef(out, (int2)(x, y), float3);
}