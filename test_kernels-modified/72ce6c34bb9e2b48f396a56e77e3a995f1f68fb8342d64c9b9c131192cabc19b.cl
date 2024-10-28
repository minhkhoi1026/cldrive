//{"d_I":1,"d_Ne":0,"d_sums":2,"d_sums2":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((max_global_work_dim(0))) kernel void prepare_kernel(long d_Ne, global float* restrict d_I, global float* restrict d_sums, global float* restrict d_sums2) {
  for (long ei = 0; ei < d_Ne; ++ei) {
    d_sums[hook(2, ei)] = d_I[hook(1, ei)];
    d_sums2[hook(3, ei)] = d_I[hook(1, ei)] * d_I[hook(1, ei)];
  }
}