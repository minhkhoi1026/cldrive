//{"A":1,"B":2,"C":0,"wA":3,"wB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMul(global float* C, global float* A, global float* B, int wA, int wB) {
  int tx = get_global_id(0);
  int ty = get_global_id(1);

  float value = 0;
  for (int k = 0; k < wA; ++k) {
    float elementA = A[hook(1, ty * wA + k)];
    float elementB = B[hook(2, k * wB + tx)];
    value += elementA * elementB;
  }

  C[hook(0, ty * wA + tx)] = value;
}