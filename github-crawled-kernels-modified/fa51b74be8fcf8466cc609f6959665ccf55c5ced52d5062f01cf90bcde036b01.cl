//{"Bloom":1,"RGBAin":0,"RGBAout":2,"intensity":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCombine(read_only image2d_t RGBAin, read_only image2d_t Bloom, write_only image2d_t RGBAout, float intensity) {
  const sampler_t sampler = 0 | 0x10 | 4;

  const int gx = get_global_id(0);
  const int gy = get_global_id(1);
  const float gw = get_global_size(0);
  const float gh = get_global_size(1);

  float2 pixel = (float2)(gx, gy);

  float4 RGBA = read_imagef(RGBAin, sampler, pixel);
  float4 BLOOM = read_imagef(Bloom, sampler, pixel) * exp(intensity * dot((float4)(0.2126, 0.7152, 0.0722, 0.0), RGBA));

  write_imagef(RGBAout, (int2)(gx, gy), RGBA + BLOOM);
}