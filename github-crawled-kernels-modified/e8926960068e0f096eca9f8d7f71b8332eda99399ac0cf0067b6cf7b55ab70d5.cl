//{"b0":9,"b1":10,"b2":11,"b3":12,"coarse":1,"detail":2,"height":4,"out":0,"t0":5,"t1":6,"t2":7,"t3":8,"width":3,"xtrans":14,"xtrans[row % 6]":13}
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
  return xtrans[hook(14, row % 6)][hook(13, col % 6)];
}

float4 weight(const float4 c1, const float4 c2, const float sharpen) {
  const float wc = native_exp(-((c1.y - c2.y) * (c1.y - c2.y) + (c1.z - c2.z) * (c1.z - c2.z)) * sharpen);
  const float wl = native_exp(-(c1.x - c2.x) * (c1.x - c2.x) * sharpen);
  return (float4)(wl, wc, wc, 1.0f);
}

kernel void eaw_synthesize(write_only image2d_t out, read_only image2d_t coarse, read_only image2d_t detail, const int width, const int height, const float t0, const float t1, const float t2, const float t3, const float b0, const float b1, const float b2, const float b3) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  const float4 threshold = (float4)(t0, t1, t2, t3);
  const float4 boost = (float4)(b0, b1, b2, b3);
  float4 c = read_imagef(coarse, sampleri, (int2)(x, y));
  float4 d = read_imagef(detail, sampleri, (int2)(x, y));
  float4 amount = copysign(max((float4)(0.0f), fabs(d) - threshold), d);
  float4 sum = c + boost * amount;
  sum.w = c.w;
  write_imagef(out, (int2)(x, y), sum);
}