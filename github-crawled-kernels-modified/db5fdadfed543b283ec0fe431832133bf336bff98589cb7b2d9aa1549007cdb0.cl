//{"a":0,"alpha":3,"b":1,"beta":4,"c":2,"n":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm(global float* a, global float* b, global float* c, float alpha, float beta, int n) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  if ((i < n) && (j < n)) {
    c[hook(2, i * n + j)] *= beta;
    for (int k = 0; k < n; k++) {
      c[hook(2, i * n + j)] += alpha * a[hook(0, i * n + k)] * b[hook(1, k * n + j)];
    }
  }
}