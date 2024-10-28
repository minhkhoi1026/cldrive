//{"A":0,"B":1,"C":4,"wA":2,"wB":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mat_mul(global const float* A, global const float* B, const int wA, const int wB, global float* C) {
  const int tx = get_global_id(0);
  const int ty = get_global_id(1);

  float res = 0;

  for (unsigned i = 0; i < wA; ++i) {
    res += A[hook(0, tx * wA + i)] * B[hook(1, i * wB + ty)];
  }
  C[hook(4, tx * (wB) + ty)] = res;
}