//{"a":0,"b":1,"col":2,"com":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cose(global double* a, global double* b, unsigned long col, unsigned char com) {
  unsigned long i = get_global_id(0) * col + get_global_id(1);
  double aa, bb;
  if (com) {
    aa = a[hook(0, i)];
    bb = b[hook(1, i)];
    a[hook(0, i)] = cos(aa) * cosh(bb);
    b[hook(1, i)] = -1.0 * sin(aa) * sinh(bb);
  } else {
    a[hook(0, i)] = cos(a[hook(0, i)]);
  }
}