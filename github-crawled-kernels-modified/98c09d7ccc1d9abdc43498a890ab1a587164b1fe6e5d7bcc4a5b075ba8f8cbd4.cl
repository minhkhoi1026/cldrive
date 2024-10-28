//{"dstOffset":3,"input":0,"output":1,"srcOffset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyImageToImage1d(read_only image1d_t input, write_only image1d_t output, int4 srcOffset, int4 dstOffset) {
  const int x = get_global_id(0);

  const int srcCoord = x + srcOffset.x;
  const int dstCoord = x + dstOffset.x;
  const uint4 c = read_imageui(input, srcCoord);
  write_imageui(output, dstCoord, c);
}