//{"a":0,"c":2,"num":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mainKernel(global const float* a, const long num, global float* c) {
  long iGID = get_global_id(0) << num;
  long k = 1 << num;
  long i;

  for (i = 0; i < k; i++)
    c[hook(2, iGID + i)] = a[hook(0, iGID + i)];
}