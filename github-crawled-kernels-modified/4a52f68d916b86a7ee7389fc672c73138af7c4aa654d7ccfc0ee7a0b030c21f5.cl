//{"N":4,"a":0,"b":1,"c":2,"d":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_fma(global const float* a, global const float* b, global const float* c, global float* d, int N) {
  int nIndex = get_global_id(0);
  if (nIndex >= N)
    return;
  d[hook(3, nIndex)] = a[hook(0, nIndex)] * b[hook(1, nIndex)] + c[hook(2, nIndex)];
}