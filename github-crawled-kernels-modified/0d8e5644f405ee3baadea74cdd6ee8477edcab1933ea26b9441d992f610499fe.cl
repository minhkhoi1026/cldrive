//{"out":3,"x":0,"y":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_mix(const global float* x, const global float* y, const global float* z, global float* out) {
  unsigned int gid = get_global_id(0);
  out[hook(3, gid)] = mix(x[hook(0, gid)], y[hook(1, gid)], z[hook(2, gid)]);
}