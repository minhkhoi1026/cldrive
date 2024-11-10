//{"A":1,"A_width":3,"B":2,"C":0,"C_height":5,"C_width":4,"tA":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMult(global float* restrict C, global float* A, global float* B, int A_width, int C_width, int C_height) {
  for (int i = 0; i < C_height; i++) {
    float tA[1024];
    for (int k = 0; k < A_width; k++)
      tA[hook(6, k)] = A[hook(1, i * A_width + k)];

    for (int j = 0; j < C_width; j++) {
      float running_sum = 0.0f;
      for (int k = 0; k < A_width; k++) {
        running_sum += tA[hook(6, k)] * B[hook(2, k * C_width + j)];
      }
      C[hook(0, i * C_width + j)] = running_sum;
    }
  }
}