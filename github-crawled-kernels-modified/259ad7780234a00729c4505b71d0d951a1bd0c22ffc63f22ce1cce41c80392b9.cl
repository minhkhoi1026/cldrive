//{"dstImage":1,"srcImage":0,"thresholdLevel":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void msa_threshold(read_only image2d_t srcImage, write_only image2d_t dstImage, const float thresholdLevel) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  float4 float3 = read_imagef(srcImage, 2 | 0x10, coords);
  write_imagei(dstImage, coords, isgreaterequal(float3, thresholdLevel));
}