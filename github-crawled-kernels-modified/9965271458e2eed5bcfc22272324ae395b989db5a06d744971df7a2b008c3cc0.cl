//{"buf":0,"cArray1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int cArray1[3] = {1, 2, 3};
kernel void brahmaKernel(global int* buf) {
  buf[hook(0, 0)] = 1 + cArray1[hook(1, 1)];
}