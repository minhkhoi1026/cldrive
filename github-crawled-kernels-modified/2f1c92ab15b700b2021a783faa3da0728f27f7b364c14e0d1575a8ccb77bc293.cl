//{"N":0,"alpha":3,"alpha_betaB":4,"betaB":2,"current":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_alpha_betaB(const int N, const int current, global const float* betaB, global const float* alpha, global float* alpha_betaB) {
  size_t gx = get_global_id(0);
  size_t gy = get_global_id(1);

  if (gx < N && gy < N) {
    alpha_betaB[hook(4, gy * N + gx)] = alpha[hook(3, current + gy)] * betaB[hook(2, gx)];
  }
}