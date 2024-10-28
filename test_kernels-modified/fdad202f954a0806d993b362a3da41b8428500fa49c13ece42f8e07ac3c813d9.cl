//{"N":0,"alpha_d":2,"b_d":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FWD_calc_alpha(const int N, global const float* b_d, global float* alpha_d) {
  unsigned int idx = get_global_id(0);

  if (idx < N) {
    alpha_d[hook(2, idx)] *= b_d[hook(1, idx)];
  }
}