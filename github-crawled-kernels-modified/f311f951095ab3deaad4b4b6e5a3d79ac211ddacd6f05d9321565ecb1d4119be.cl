//{"A":1,"A_width":3,"B":2,"C":0,"C_height":5,"C_width":4,"l_b":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMult(global float* restrict C, global float* A, global float* B, int A_width, int C_width, int C_height) {
  float l_b[1024 * 1024];
  for (int i = 0; i < 1024; i++) {
    for (int j = 0; j < 1024; j++) {
      l_b[hook(6, j * C_width + i)] = B[hook(2, i * C_width + j)];
    }
  }

  for (int i = 0; i < C_height; i++) {
    for (int j = 0; j < C_width; j++) {
      float running_sum = 0.0f;
      for (int k = 0; k < A_width; k++) {
        running_sum += A[hook(1, i * A_width + k)] * l_b[hook(6, j * C_width + k)];
      }
      C[hook(0, i * C_width + j)] = running_sum;
    }
  }
}