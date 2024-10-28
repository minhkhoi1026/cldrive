//{"a":0,"b":1,"col":3,"com":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void absolute(global double* a, global double* b, unsigned char com, unsigned long col) {
  unsigned long current = get_global_id(0) * col + get_global_id(1);
  double aa, bb;
  if (com) {
    aa = a[hook(0, current)];
    bb = b[hook(1, current)];
    a[hook(0, current)] = sqrt(aa * aa + bb * bb);
  } else {
    a[hook(0, current)] = fabs(a[hook(0, current)]);
  }
}