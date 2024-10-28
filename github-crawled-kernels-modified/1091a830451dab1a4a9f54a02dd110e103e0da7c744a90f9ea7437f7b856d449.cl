//{"from":0,"ix_plane":2,"to":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy(global float* from, global float* to, unsigned ix_plane) {
  size_t x = get_global_id(0);
  size_t z = get_global_id(1);

  to[hook(1, ((z) * 128 + (x)))] = from[hook(0, ((z) * 128 * 128 + (ix_plane) * 128 + (x)))];
}