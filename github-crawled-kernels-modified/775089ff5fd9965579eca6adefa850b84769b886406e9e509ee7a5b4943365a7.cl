//{"dst":1,"hist":4,"levels":3,"radius":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
kernel void oilify2(read_only image2d_t src, write_only image2d_t dst, int radius, int levels) {
  uint4 hist[30];

  for (int i = 0; i < levels; ++i) {
    hist[hook(4, i)] = (uint4)(0, 0, 0, 0);
  }

  int2 coords = (int2)(get_global_id(0), get_global_id(1));

  for (int i = -radius; i <= radius; ++i) {
    for (int j = -radius; j <= radius; ++j) {
      uint4 float3 = read_imageui(src, sampler, coords + (int2)(i, j));
      hist[hook(4, float3.w)].xyz += float3.xyz;
      hist[hook(4, float3.w)].w += 1;
    }
  }

  uint4 max = 0;

  for (int i = 0; i < levels; ++i) {
    if (hist[hook(4, i)].w > max.w) {
      max = hist[hook(4, i)];
    }
  }

  float4 res = convert_float4(max);
  res /= res.w;
  res.w = 1.0f;

  write_imagef(dst, coords, clamp(res, 0.0f, 1.0f));
}