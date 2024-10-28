//{"A":1,"B":2,"C":0,"widthA":3,"widthB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm_slow(global float* C, global const float* A, global const float* B, const int widthA, const int widthB) {
  int ty = get_global_id(0);
  int tx = get_global_id(1);

  float value = 0;
  for (int k = 0; k < widthA; ++k) {
    float elementA = A[hook(1, ty * widthA + k)];
    float elementB = B[hook(2, k * widthB + tx)];
    value += elementA * elementB;
  }
  C[hook(0, ty * widthB + tx)] = value;
}