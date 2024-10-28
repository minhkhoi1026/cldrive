//{"A":1,"B":2,"C":3,"wA":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_orig(const int wA, global float* A, global float* B, global float* C) {
  int row = get_global_id(1);

  int col = get_global_id(0);

  float cSum = 0.0f;

  for (int i = 0; i < wA; i++) {
    cSum += B[hook(2, row * wA + i)] * A[hook(1, i * wA + col)];
  }

  C[hook(3, row * wA + col)] = cSum + C[hook(3, row * wA + col)];
}