//{"d_Ne":0,"d_sums":1,"d_sums2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_kernel(long d_Ne, global float* restrict d_sums, global float* restrict d_sums2) {
  float sum_1 = 0, sum_2 = 0;
  for (long i = 0; i < d_Ne; ++i) {
    sum_1 += d_sums[hook(1, i)];
    sum_2 += d_sums2[hook(2, i)];
  }
  d_sums[hook(1, 0)] = sum_1;
  d_sums2[hook(2, 0)] = sum_2;
}