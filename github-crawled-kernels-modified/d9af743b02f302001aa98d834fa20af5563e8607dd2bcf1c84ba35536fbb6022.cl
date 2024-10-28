//{"offset":1,"stride":0,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum_pairwise(const unsigned int stride, const unsigned int offset, global float* x) {
  const unsigned int gid = get_global_id(0);
  x[hook(2, offset + 2 * gid * stride)] += x[hook(2, offset + (2 * gid + 1) * stride)];
}