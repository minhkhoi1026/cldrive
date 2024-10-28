//{"a":0,"b":1,"c":2,"com":5,"d":3,"typ":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void diag(global double* a, global double* b, global double* c, global double* d, unsigned char typ, unsigned char com) {
  unsigned long i = get_global_id(0);
  unsigned long col = get_global_size(0);
  if (typ) {
    a[hook(0, i * col + i)] = c[hook(2, i)];
    if (com) {
      b[hook(1, i * col + i)] = d[hook(3, i)];
    }
  } else {
    a[hook(0, i)] = c[hook(2, i * col + i)];
    if (com) {
      b[hook(1, i)] = d[hook(3, i * col + i)];
    }
  }
}