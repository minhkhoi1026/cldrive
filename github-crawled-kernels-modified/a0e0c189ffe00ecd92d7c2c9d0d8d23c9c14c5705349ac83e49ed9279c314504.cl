//{"a":0,"b":1,"col":2,"com":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tgh(global double* a, global double* b, unsigned long col, unsigned char com) {
  unsigned long i = get_global_id(0) * col + get_global_id(1);
  double c;
  if (com) {
    c = cosh(a[hook(0, i)] * 2) + cos(b[hook(1, i)] * 2);
    a[hook(0, i)] = sinh(a[hook(0, i)] * 2) / c;
    b[hook(1, i)] = sin(b[hook(1, i)] * 2) / c;
  } else {
    a[hook(0, i)] = tanh(a[hook(0, i)]);
  }
}