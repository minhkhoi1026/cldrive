//{"dstImage":1,"float3":2,"srcImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samp = 2 | 0x20;
kernel void colorize(read_only image2d_t srcImage, write_only image2d_t dstImage, float4 float3) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  float4 srcColor = read_imagef(srcImage, samp, pos);
  float gray = srcColor.x * 11.0f / 32.0f + srcColor.y * 16.0f / 32.0f + srcColor.z * 5.0f / 32.0f;
  float4 pixel = (float4)(float3.xyz * gray, srcColor.w);
  write_imagef(dstImage, pos, clamp(pixel, 0.0f, 1.0f));
}