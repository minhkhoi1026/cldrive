//{"d_I":1,"d_Ne":0,"d_sums":2,"d_sums2":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((num_simd_work_items(4))) __attribute__((reqd_work_group_size(32, 1, 1))) kernel void prepare_kernel(long d_Ne, global float* restrict d_I, global float* restrict d_sums, global float* restrict d_sums2) {
  int bx = get_group_id(0);
  int tx = get_local_id(0);
  int ei = bx * 32 + tx;

  if (ei < d_Ne) {
    d_sums[hook(2, ei)] = d_I[hook(1, ei)];
    d_sums2[hook(3, ei)] = d_I[hook(1, ei)] * d_I[hook(1, ei)];
  }
}