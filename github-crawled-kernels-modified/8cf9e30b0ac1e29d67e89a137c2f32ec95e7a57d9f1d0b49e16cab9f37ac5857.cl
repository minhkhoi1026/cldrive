//{"dstOffset":2,"float3":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FillImage1d(write_only image1d_t output, uint4 float3, int4 dstOffset) {
  const int x = get_global_id(0);

  const int dstCoord = x + dstOffset.x;
  write_imageui(output, dstCoord, float3);
}