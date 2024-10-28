//{"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foobar(global int* x) {
  const int gid = get_global_id(0);
  x[hook(0, gid)] = gid;
}