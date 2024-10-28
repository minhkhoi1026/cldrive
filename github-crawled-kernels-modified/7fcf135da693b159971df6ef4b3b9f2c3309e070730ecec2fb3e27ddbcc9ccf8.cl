//{"a":1,"b":2,"c":3,"row":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mainKernel(const long row, global const float* a, const float b, global float* c) {
  int iGID = get_global_id(0) + row * get_global_id(1);

  c[hook(3, iGID)] = a[hook(1, iGID)] + b;
}