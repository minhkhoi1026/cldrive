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

kernel void ppg_demosaic_redblue(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const unsigned int filters, local float4* buffer) {
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
    buffer[hook(5, bufidx)] = read_imagef(in, sampleri, (int2)(xx, yy));
  }

  buffer += mad24(ylid + 1, stride, xlid + 1);

  barrier(0x01);

  if (x >= width || y >= height)
    return;

  const int row = y;
  const int col = x;
  const int c = FC(row, col, filters);
  float4 float3 = buffer[hook(5, 0)];

  if (c == 1 || c == 3) {
    float4 nt = buffer[hook(5, -stride)];
    float4 nb = buffer[hook(5, stride)];
    float4 nl = buffer[hook(5, -1)];
    float4 nr = buffer[hook(5, 1)];
    if (FC(row, col + 1, filters) == 0) {
      float3.z = (nt.z + nb.z + 2.0f * float3.y - nt.y - nb.y) * 0.5f;
      float3.x = (nl.x + nr.x + 2.0f * float3.y - nl.y - nr.y) * 0.5f;
    } else {
      float3.x = (nt.x + nb.x + 2.0f * float3.y - nt.y - nb.y) * 0.5f;
      float3.z = (nl.z + nr.z + 2.0f * float3.y - nl.y - nr.y) * 0.5f;
    }
  } else {
    float4 ntl = buffer[hook(5, -stride - 1)];
    float4 ntr = buffer[hook(5, -stride + 1)];
    float4 nbl = buffer[hook(5, stride - 1)];
    float4 nbr = buffer[hook(5, stride + 1)];

    if (c == 0) {
      const float diff1 = fabs(ntl.z - nbr.z) + fabs(ntl.y - float3.y) + fabs(nbr.y - float3.y);
      const float guess1 = ntl.z + nbr.z + 2.0f * float3.y - ntl.y - nbr.y;
      const float diff2 = fabs(ntr.z - nbl.z) + fabs(ntr.y - float3.y) + fabs(nbl.y - float3.y);
      const float guess2 = ntr.z + nbl.z + 2.0f * float3.y - ntr.y - nbl.y;
      if (diff1 > diff2)
        float3.z = guess2 * 0.5f;
      else if (diff1 < diff2)
        float3.z = guess1 * 0.5f;
      else
        float3.z = (guess1 + guess2) * 0.25f;
    } else {
      const float diff1 = fabs(ntl.x - nbr.x) + fabs(ntl.y - float3.y) + fabs(nbr.y - float3.y);
      const float guess1 = ntl.x + nbr.x + 2.0f * float3.y - ntl.y - nbr.y;
      const float diff2 = fabs(ntr.x - nbl.x) + fabs(ntr.y - float3.y) + fabs(nbl.y - float3.y);
      const float guess2 = ntr.x + nbl.x + 2.0f * float3.y - ntr.y - nbl.y;
      if (diff1 > diff2)
        float3.x = guess2 * 0.5f;
      else if (diff1 < diff2)
        float3.x = guess1 * 0.5f;
      else
        float3.x = (guess1 + guess2) * 0.25f;
    }
  }
  write_imagef(out, (int2)(x, y), float3);
}