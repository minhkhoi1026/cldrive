//{"a":1,"b":2,"c":3,"off":0,"tmp":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addXY(double off, global double2* restrict a, global double2* restrict b, global double2* restrict c, local double* tmp) {
  int i = get_global_id(0);
  tmp[hook(4, i)] = a[hook(1, i)].x + b[hook(2, i)].x;
  c[hook(3, i)].x = tmp[hook(4, i)] + off;
  c[hook(3, i)].y = a[hook(1, i)].y + b[hook(2, i)].y;
}