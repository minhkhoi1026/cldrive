//{"N":0,"alpha_d":3,"scale_factor":1,"scale_factor_index":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FWD_scaling(const int N, global const float* scale_factor, const int scale_factor_index, global float* alpha_d) {
  unsigned int idx = get_global_id(0);

  if (idx < N) {
    alpha_d[hook(3, idx)] /= scale_factor[hook(1, scale_factor_index)];
  }
}