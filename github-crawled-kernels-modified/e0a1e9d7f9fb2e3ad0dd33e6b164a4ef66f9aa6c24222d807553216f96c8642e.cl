//{"N":3,"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_add_double(global const double* a, global const double* b, global double* c, int N) {
  int nIndex = get_global_id(0);
  if (nIndex < N) {
    c[hook(2, nIndex)] = a[hook(0, nIndex)] + b[hook(1, nIndex)];
  }
}