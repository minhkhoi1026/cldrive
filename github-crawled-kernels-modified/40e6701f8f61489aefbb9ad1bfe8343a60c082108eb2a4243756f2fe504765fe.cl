//{"dst":1,"levels_one_less":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
kernel void oilify_prepare(read_only image2d_t src, write_only image2d_t dst, int levels_one_less) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  float4 float3 = read_imagef(src, coords);

  uint4 res = convert_uint4(float3 * 255);
  res.w = (unsigned int)round((float3.x + float3.y + float3.z) * levels_one_less * (1.0f / 3.0f));

  write_imageui(dst, coords, res);
}