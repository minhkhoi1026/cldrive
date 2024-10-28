//{"N":0,"b":3,"beta":2,"betaB":4,"pos":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BK_BetaB(const int N, const int pos, global const float* beta, global const float* b, global float* betaB) {
  size_t idx = get_global_id(0);
  if (idx < N) {
    betaB[hook(4, idx)] = b[hook(3, pos + idx)] * beta[hook(2, pos + idx)];
  }
}