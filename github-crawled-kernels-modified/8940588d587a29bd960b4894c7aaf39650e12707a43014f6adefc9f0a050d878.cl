//{"output":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Test(global uchar4* output, unsigned int width) {
  unsigned int gi = get_global_id(0);
  unsigned int gj = get_global_id(1);

  unsigned int index = gj * width + gi;
  output[hook(0, index)].x = 255 - output[hook(0, index)].x;
  output[hook(0, index)].y = 255 - output[hook(0, index)].y;
  output[hook(0, index)].z = 255 - output[hook(0, index)].z;
}