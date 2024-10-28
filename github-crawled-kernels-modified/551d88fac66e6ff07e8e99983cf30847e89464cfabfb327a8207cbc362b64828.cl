//{"dstImage":1,"srcImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
;
;
;
;
;
kernel void msa_invert(read_only image2d_t srcImage, write_only image2d_t dstImage) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  sampler_t smp = 2 | 0x10;
  float4 float3 = read_imagef(srcImage, smp, coords);
  float3 = (float4)(1.0f, 1.0f, 1.0f, 1.0f) - (float4)(float3.xyz, 0.0f);
  write_imagef(dstImage, coords, float3);
}