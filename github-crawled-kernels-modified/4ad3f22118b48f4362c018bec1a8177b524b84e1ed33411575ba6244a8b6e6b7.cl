//{"B":1,"N":5,"alpha":3,"alpha_beta":4,"beta":0,"betaB":2,"current":6,"previous":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_betaB_alphabeta(global const float* beta, global const float* B, global float* betaB, global const float* alpha, global float* alpha_beta, const int N, const int current, const int previous) {
  size_t idx = get_global_id(0);
  if (idx < N) {
    betaB[hook(2, idx)] = beta[hook(0, previous + idx)] * B[hook(1, previous + idx)];
    alpha_beta[hook(4, idx)] = beta[hook(0, current + idx)] * alpha[hook(3, current + idx)];
  }
}