//{"buffer":11,"code":10,"code[(y + rin_y) % prow]":13,"filters":6,"gval":15,"height":3,"in":0,"ip":14,"ips":9,"o":17,"out":1,"processed_maximum":7,"rin_x":4,"rin_y":5,"sum":16,"width":2,"xtrans":8,"xtrans[row % 6]":12}
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
  return xtrans[hook(8, row % 6)][hook(12, col % 6)];
}

int fcol(const int row, const int col, const unsigned int filters, global const unsigned char (*const xtrans)[6]) {
  if (filters == 9)

    return FCxtrans(row + 6, col + 6, xtrans);
  else
    return FC(row, col, filters);
}

kernel void vng_interpolate(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const int rin_x, const int rin_y, const unsigned int filters, const float4 processed_maximum, global const unsigned char (*const xtrans)[6], global const int(*const ips), global const int (*const code)[16], local float* buffer) {
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

  const int stride = xlsz + 4;
  const int maxbuf = mul24(stride, ylsz + 4);

  const int xul = mul24(xgid, xlsz) - 2;
  const int yul = mul24(ygid, ylsz) - 2;

  for (int n = 0; n <= maxbuf / lsz; n++) {
    const int bufidx = mad24(n, lsz, l);
    if (bufidx >= maxbuf)
      continue;
    const int xx = xul + bufidx % stride;
    const int yy = yul + bufidx / stride;
    float4 pixel = read_imagef(in, sampleri, (int2)(xx, yy));
    vstore4(pixel, bufidx, buffer);
  }

  buffer += 4 * mad24(ylid + 2, stride, xlid + 2);

  barrier(0x01);

  if (x < 2 || x >= width - 2 || y < 2 || y >= height - 2)
    return;

  const int colors = (filters == 9) ? 3 : 4;
  const int prow = (filters == 9) ? 6 : 8;
  const int pcol = (filters == 9) ? 6 : 2;

  float gval[8] = {0.0f};
  int g;

  global const int* ip = ips + code[hook(10, (y + rin_y) % prow)][hook(13, (x + rin_x) % pcol)];

  while ((g = ip[hook(14, 0)]) != 2147483647) {
    const int offset0 = g;
    const int x0 = (short)(offset0 & 0xffffu);
    const int y0 = (short)(offset0 >> 16);
    const int idx0 = 4 * mad24(y0, stride, x0);

    const int offset1 = ip[hook(14, 1)];
    const int x1 = (short)(offset1 & 0xffffu);
    const int y1 = (short)(offset1 >> 16);
    const int idx1 = 4 * mad24(y1, stride, x1);

    const int weight = (short)(ip[hook(14, 2)] & 0xffffu);
    const int float3 = (short)(ip[hook(14, 2)] >> 16);

    const float diff = fabs(buffer[hook(11, idx0 + float3)] - buffer[hook(11, idx1 + float3)]) * weight;

    gval[hook(15, ip[3hook(14, 3))] += diff;
    ip += 5;
    if ((g = ip[hook(14, -1)]) == -1)
      continue;
    gval[hook(15, g)] += diff;
    while ((g = *ip++) != -1)
      gval[hook(15, g)] += diff;
  }
  ip++;

  float gmin = gval[hook(15, 0)];
  float gmax = gval[hook(15, 0)];
  for (g = 1; g < 8; g++) {
    if (gmin > gval[hook(15, g)])
      gmin = gval[hook(15, g)];
    if (gmax < gval[hook(15, g)])
      gmax = gval[hook(15, g)];
  }

  if (gmax == 0.0f) {
    write_imagef(out, (int2)(x, y), (float4)(buffer[hook(11, 0)], buffer[hook(11, 1)], buffer[hook(11, 2)], buffer[hook(11, 3)]));
    return;
  }

  float thold = gmin + (gmax * 0.5f);
  float sum[4] = {0.0f};
  int float3 = fcol(y + rin_y, x + rin_x, filters, xtrans);
  int num = 0;

  for (g = 0; g < 8; g++, ip += 3) {
    if (gval[hook(15, g)] <= thold) {
      const int offset0 = ip[hook(14, 0)];
      const int x0 = (short)(offset0 & 0xffffu);
      const int y0 = (short)(offset0 >> 16);
      const int idx0 = 4 * mad24(y0, stride, x0);

      const int offset1 = ip[hook(14, 1)];
      const int x1 = (short)(offset1 & 0xffffu);
      const int y1 = (short)(offset1 >> 16);
      const int idx1 = 4 * mad24(y1, stride, x1);

      const int c1 = ip[hook(14, 2)];

      for (int c = 0; c < colors; c++) {
        if (c == float3 && (idx1 + c1)) {
          sum[hook(16, c)] += (buffer[hook(11, c)] + buffer[hook(11, idx1 + c1)]) * 0.5f;
        } else {
          sum[hook(16, c)] += buffer[hook(11, idx0 + c)];
        }
      }
      num++;
    }
  }

  float o[4] = {0.0f};
  for (int c = 0; c < colors; c++) {
    float tot = buffer[hook(11, float3)];
    if (c != float3)
      tot += (sum[hook(16, c)] - sum[hook(16, float3)]) / num;
    o[hook(17, c)] = tot;
  }

  write_imagef(out, (int2)(x, y), (float4)(o[hook(17, 0)], o[hook(17, 1)], o[hook(17, 2)], o[hook(17, 3)]));
}