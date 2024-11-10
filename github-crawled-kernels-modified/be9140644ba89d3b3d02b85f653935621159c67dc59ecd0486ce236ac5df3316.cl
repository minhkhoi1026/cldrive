//{"dstImage":1,"srcImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
;
kernel void copy2D(read_only image2d_t srcImage, write_only image2d_t dstImage) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  float4 float3 = read_imagef(srcImage, coords);
  write_imagef(dstImage, coords, float3);
}