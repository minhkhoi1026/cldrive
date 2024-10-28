//{"coarse":1,"detail":2,"filter":7,"height":4,"in":0,"scale":5,"sharpen":6,"width":3,"xtrans":9,"xtrans[row % 6]":8}
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
  return xtrans[hook(9, row % 6)][hook(8, col % 6)];
}

float4 weight(const float4 c1, const float4 c2, const float sharpen) {
  const float wc = native_exp(-((c1.y - c2.y) * (c1.y - c2.y) + (c1.z - c2.z) * (c1.z - c2.z)) * sharpen);
  const float wl = native_exp(-(c1.x - c2.x) * (c1.x - c2.x) * sharpen);
  return (float4)(wl, wc, wc, 1.0f);
}

kernel void eaw_decompose(read_only image2d_t in, write_only image2d_t coarse, write_only image2d_t detail, const int width, const int height, const int scale, const float sharpen, global const float* filter) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  const int mult = 1 << scale;

  float4 pixel = read_imagef(in, sampleri, (int2)(x, y));
  float4 sum = (float4)(0.0f);
  float4 wgt = (float4)(0.0f);
  for (int j = 0; j < 5; j++)
    for (int i = 0; i < 5; i++) {
      int xx = mad24(mult, i - 2, x);
      int yy = mad24(mult, j - 2, y);
      int k = mad24(j, 5, i);

      float4 px = read_imagef(in, sampleri, (int2)(xx, yy));
      float4 w = filter[hook(7, k)] * weight(pixel, px, sharpen);

      sum += w * px;
      wgt += w;
    }
  sum /= wgt;
  sum.w = pixel.w;

  write_imagef(detail, (int2)(x, y), pixel - sum);
  write_imagef(coarse, (int2)(x, y), sum);
}