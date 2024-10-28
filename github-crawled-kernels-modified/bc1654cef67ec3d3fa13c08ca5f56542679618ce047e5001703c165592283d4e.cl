//{"dstOffset":3,"input":0,"output":1,"srcOffset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyImageToImage2d(read_only image2d_t input, write_only image2d_t output, int4 srcOffset, int4 dstOffset) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const int2 srcCoord = (int2)(x, y) + (int2)(srcOffset.x, srcOffset.y);
  const int2 dstCoord = (int2)(x, y) + (int2)(dstOffset.x, dstOffset.y);
  const uint4 c = read_imageui(input, srcCoord);
  write_imageui(output, dstCoord, c);
}