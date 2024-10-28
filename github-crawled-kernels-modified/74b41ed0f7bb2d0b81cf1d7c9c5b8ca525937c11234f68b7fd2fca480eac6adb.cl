//{"a":0,"c":2,"num":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mainKernel(global const float* a, const long num, global float* c) {
  int iGID = get_global_id(0);

  c[hook(2, iGID)] = a[hook(0, iGID)];
}