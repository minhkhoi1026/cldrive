//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testdot(global float* a, global float* b, global float* c) {
  int gid = get_global_id(0);
  c[hook(2, gid)] = dot(a[hook(0, gid)], b[hook(1, gid)]);
}