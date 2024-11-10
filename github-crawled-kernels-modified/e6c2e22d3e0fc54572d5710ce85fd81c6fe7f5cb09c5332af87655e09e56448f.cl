//{"dstImage":1,"srcImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void msa_flipy(read_only image2d_t srcImage, write_only image2d_t dstImage) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int2 coords1 = (int2)(i, j);
  int2 coords2 = (int2)(i, get_image_height(srcImage) - j - 1.0f);
  float4 float3 = read_imagef(srcImage, 2 | 0x10, coords1);
  write_imagef(dstImage, coords2, float3);
}