//{"a":0,"c":2,"num":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mainKernel(global const int* a, const long num, global int* c) {
  unsigned long iGID = get_global_id(0) * 4;

  c[hook(2, iGID)] = a[hook(0, iGID)];
  c[hook(2, iGID + 1)] = a[hook(0, iGID + 1)];
  c[hook(2, iGID + 2)] = a[hook(0, iGID + 2)];
  c[hook(2, iGID + 3)] = a[hook(0, iGID + 3)];
}