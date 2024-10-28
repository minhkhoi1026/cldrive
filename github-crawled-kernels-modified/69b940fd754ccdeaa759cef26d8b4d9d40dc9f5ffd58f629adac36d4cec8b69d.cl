//{"a":0,"b":1,"col":3,"com":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void norm(global double* a, global double* b, unsigned char com, unsigned long col) {
  unsigned long i = get_global_id(0) * col + get_global_id(1);
  double aa = a[hook(0, i)], bb;
  if (com) {
    bb = b[hook(1, i)];
    a[hook(0, i)] = aa * aa - bb * bb;
    b[hook(1, i)] = bb * 2 * aa;
  } else {
    a[hook(0, i)] = aa * aa;
  }
}