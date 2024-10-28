//{"a":0,"alpha":3,"b":1,"col":2,"com":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lerelu(global double* a, global double* b, unsigned long col, double alpha, unsigned char com) {
  unsigned long i = get_global_id(0) * col + get_global_id(1);

  double aa = a[hook(0, i)];
  if (aa < alpha * aa) {
    a[hook(0, i)] = alpha * aa;
    if (com) {
      b[hook(1, i)] = alpha * b[hook(1, i)];
    }
  }
}