//{"A":1,"B":2,"C":0,"nn":3,"spin":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fmma(global float* C, global float* A, global float* B, long nn, long spin) {
  const int xx = get_global_id(0);
  const int yy = get_global_id(1);

  for (long it = 0; it < spin; ++it) {
    float sum = C[hook(0, nn * yy + xx)];

    for (int kk = 0; kk < nn; ++kk) {
      sum += A[hook(1, nn * yy + kk)] * B[hook(2, nn * kk + xx)];
    }

    C[hook(0, nn * yy + xx)] = sum;
  }
}