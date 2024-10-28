//{"RGBAin":0,"RGBAout":1,"threshold":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clFilter(read_only image2d_t RGBAin, write_only image2d_t RGBAout, float threshold) {
  const sampler_t sampler = 0 | 0x20 | 4;

  const int gx = get_global_id(0);
  const int gy = get_global_id(1);

  float2 pixel = (float2)(gx + 0.5, gy + 0.5);

  float4 RGBA = read_imagef(RGBAin, sampler, pixel);

  float luminance = dot((float4)(0.2126, 0.7152, 0.0722, 0.0), RGBA);

  if (luminance <= threshold) {
    RGBA = (float4)(0.0, 0.0, 0.0, 0.0);
  }

  write_imagef(RGBAout, (int2)(gx, gy), RGBA);
}