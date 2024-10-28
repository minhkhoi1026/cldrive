//{"N":0,"beta":2,"ll_d":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BK_scaling(const int N, global const float* ll_d, global float* beta) {
  unsigned int idx = get_global_id(0);

  if (idx < N) {
    beta[hook(2, idx)] /= ll_d[hook(1, 0)];
  }
}