//{"out":2,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_step(const global float* x, const global float* y, global float* out) {
  unsigned int gid = get_global_id(0);
  out[hook(2, gid)] = step(x[hook(0, gid)], y[hook(1, gid)]);
}