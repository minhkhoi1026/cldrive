//{"blend":4,"colorkey_rgba":2,"dst":1,"similarity":3,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10;
kernel void colorkey_blend(read_only image2d_t src, write_only image2d_t dst, float4 colorkey_rgba, float similarity, float blend) {
  int2 loc = (int2)(get_global_id(0), get_global_id(1));
  float4 pixel = read_imagef(src, sampler, loc);
  float diff = distance(pixel.xyz, colorkey_rgba.xyz);

  pixel.s3 = clamp((diff - similarity) / blend, 0.0f, 1.0f);
  write_imagef(dst, loc, pixel);
}