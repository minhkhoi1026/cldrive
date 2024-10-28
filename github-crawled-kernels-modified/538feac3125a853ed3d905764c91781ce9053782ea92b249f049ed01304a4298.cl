//{"a":1,"b":2,"c":3,"num":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mainKernel(const long num, global const float* a, global const float* b, global float* c) {
  int iGID = get_global_id(0);

  if (iGID < num)
    c[hook(3, iGID)] = a[hook(1, iGID)] * b[hook(2, iGID)];
}