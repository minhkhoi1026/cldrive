//{"a":0,"b":1,"c":3,"num":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mainKernel(global const float* a, const float b, const long num, global float* c) {
  int iGID = get_global_id(0);

  if (iGID < num)
    c[hook(3, iGID)] = a[hook(0, iGID)] + b;
}