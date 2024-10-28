//{"N":0,"alpha":3,"b":1,"beta":4,"prior":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FWD_init_alpha(const int N, global float* b, global float* prior, global float* alpha, global float* beta) {
  size_t idx = get_global_id(0);
  if (idx < N) {
    alpha[hook(3, idx)] = prior[hook(2, idx)] * b[hook(1, idx)];
    beta[hook(4, idx)] = 1.0f;
  }
}