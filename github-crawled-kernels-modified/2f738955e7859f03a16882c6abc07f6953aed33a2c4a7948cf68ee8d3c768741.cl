//{"dstImage":1,"srcImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
;
;
;
kernel void msa_greyscale(read_only image2d_t srcImage, write_only image2d_t dstImage) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  sampler_t smp = 2 | 0x10;
  float4 float3 = read_imagef(srcImage, smp, coords);
  float luminance = 0.3f * float3.x + 0.59 * float3.y + 0.11 * float3.z;
  float3 = (float4)(luminance, luminance, luminance, 1.0f);
  write_imagef(dstImage, coords, float3);
}