//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void complex_add(global double2* a, global double2* b) {
  unsigned int n = get_global_id(0);
  a[hook(0, n)].x += b[hook(1, n)].x;
  a[hook(0, n)].y += b[hook(1, n)].y;
}