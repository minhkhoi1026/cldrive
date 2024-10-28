//{"N":2,"a":0,"b":1,"c":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_add(global const float* a, global const float* b, int N, global float* c) {
  int nIndex = get_global_id(0);
  if (nIndex >= N)
    return;
  c[hook(3, nIndex)] = a[hook(0, nIndex)] + b[hook(1, nIndex)];
}