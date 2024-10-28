//{"a":0,"b":1,"col":3,"com":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lognatu(global double* a, global double* b, unsigned char com, unsigned long col) {
  unsigned long current = get_global_id(0) * col + get_global_id(1);
  double n, m;
  if (com) {
    n = a[hook(0, current)];
    m = b[hook(1, current)];
    b[hook(1, current)] = atan2(m, n);
    a[hook(0, current)] = 0.5 * log(n * n + m * m);
  } else {
    a[hook(0, current)] = log(a[hook(0, current)]);
  }
}