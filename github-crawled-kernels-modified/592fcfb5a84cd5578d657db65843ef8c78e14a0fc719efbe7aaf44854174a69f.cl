//{"input":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelA(read_only image3d_t input) {
  uint4 c = read_imageui(input, (int4)(0, 0, 0, 0));
}