//{"dstImage":0,"float3":5,"limitX":3,"limitY":4,"offsetX":1,"offsetY":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fillRectWithColor(write_only image2d_t dstImage, int offsetX, int offsetY, int limitX, int limitY, float4 float3) {
  int x = get_global_id(0) + offsetX;
  int y = get_global_id(1) + offsetY;
  if (x < limitX && y < limitY)
    write_imagef(dstImage, (int2)(x, y), float3);
}