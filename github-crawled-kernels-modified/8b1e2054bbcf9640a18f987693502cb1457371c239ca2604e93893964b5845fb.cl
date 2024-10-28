//{"N":0,"a":2,"aT":3,"sm":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void TransposeSym(const int N, local float* sm, global float* a, global float* aT) {
  size_t lx = get_local_id(0);
  size_t ly = get_local_id(1);

  size_t gx = get_global_id(0);
  size_t gy = get_global_id(1);

  if ((gx < N) && (gy < N)) {
    size_t index_in = gy * N + gx;
    sm[hook(1, ly * 17 + lx)] = a[hook(2, index_in)];
  }

  barrier(0x01);

  gx = get_group_id(1) * 16 + lx;
  gy = get_group_id(0) * 16 + ly;

  if ((gx < N) && (gy < N)) {
    size_t index_out = gy * N + gx;
    aT[hook(3, index_out)] = sm[hook(1, lx * 17 + ly)];
  }
}