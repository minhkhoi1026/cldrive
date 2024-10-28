//{"pgx":2,"pgy":0,"shift":3,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void batch_slice_bw_kernel(const global float* pgy, const unsigned size, global float* pgx, const unsigned shift) {
  const unsigned i = get_global_id(0);
  if (i < size)
    pgx[hook(2, i + shift)] += pgy[hook(0, i)];
}