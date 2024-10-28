//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void complex_mult(global double2* a, global double2* b, global double2* c) {
  unsigned int n = get_global_id(0);
  c[hook(2, n)].x = a[hook(0, n)].x * b[hook(1, n)].x - a[hook(0, n)].y * b[hook(1, n)].y;
  c[hook(2, n)].y = a[hook(0, n)].x * b[hook(1, n)].y + a[hook(0, n)].y * b[hook(1, n)].x;
}