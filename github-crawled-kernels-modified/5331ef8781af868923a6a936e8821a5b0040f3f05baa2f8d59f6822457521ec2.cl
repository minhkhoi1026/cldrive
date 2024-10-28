//{"input":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelB(read_only image3d_t input) {
  float4 f = read_imagef(input, (int4)(0, 0, 0, 0));
}