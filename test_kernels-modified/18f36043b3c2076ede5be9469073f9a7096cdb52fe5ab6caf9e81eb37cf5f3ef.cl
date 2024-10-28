//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addCopy(global double* a, global const double* b, global const double* c) {
  int gid = get_global_id(0);
  a[hook(0, gid)] = b[hook(1, gid)] + c[hook(2, gid)];
}