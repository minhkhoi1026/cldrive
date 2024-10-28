//{"N":3,"alpha_beta":0,"current":4,"gamma":1,"ll_d":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_alphabeta_update_gamma(global const float* alpha_beta, global float* gamma, global const float* ll_d, const int N, const unsigned int current) {
  unsigned int idx = get_global_id(0);
  if (idx < N) {
    gamma[hook(1, current + idx)] = alpha_beta[hook(0, idx)] / ll_d[hook(2, 0)];
  }
}