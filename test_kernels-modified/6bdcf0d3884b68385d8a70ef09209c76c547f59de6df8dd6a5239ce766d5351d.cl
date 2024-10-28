//{"k":3,"pgx":5,"pgy":2,"px":0,"py":1,"size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pown_bw_kernel(const global float* px, const global float* py, const global float* pgy, const int k, const unsigned size, global float* pgx) {
  const unsigned i = get_global_id(0);
  if (i < size)
    pgx[hook(5, i)] += k * pgy[hook(2, i)] * py[hook(1, i)] / px[hook(0, i)];
}