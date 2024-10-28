//{"N":0,"alpha":5,"alpha_beta":7,"b":4,"beta":3,"betaB":6,"current":1,"previous":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_betaB_alphabeta(const int N, const int current, const int previous, global const float* beta, global const float* b, global const float* alpha, global float* betaB, global float* alpha_beta) {
  size_t idx = get_global_id(0);
  if (idx < N) {
    betaB[hook(6, idx)] = beta[hook(3, previous + idx)] * b[hook(4, previous + idx)];
    alpha_beta[hook(7, idx)] = beta[hook(3, current + idx)] * alpha[hook(5, current + idx)];
  }
}