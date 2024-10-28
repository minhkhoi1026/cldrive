//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void complex_exp(global double2* a) {
  unsigned int n = get_global_id(0);
  double e = exp(a[hook(0, n)].x);
  double s, c;
  s = sincos(a[hook(0, n)].y, &c);
  a[hook(0, n)].x = c * e;
  a[hook(0, n)].y = s * e;
}