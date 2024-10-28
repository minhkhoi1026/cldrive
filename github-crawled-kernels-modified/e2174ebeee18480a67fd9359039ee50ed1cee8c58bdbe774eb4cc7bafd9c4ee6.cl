//{"B_d":2,"N":0,"betaB_d":3,"beta_d":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BK_update_beta(const int N, global const float* beta_d, global const float* B_d, global float* betaB_d) {
  unsigned int idx = get_global_id(0);
  if (idx < N) {
    betaB_d[hook(3, idx)] = B_d[hook(2, idx)] * beta_d[hook(1, idx)];
  }
}