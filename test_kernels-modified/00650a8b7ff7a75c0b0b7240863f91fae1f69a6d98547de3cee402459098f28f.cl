//{"A":0,"B":1,"C":2,"a_buffer":3,"acc":5,"acc[nd]":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMultiplication(global float const* restrict A, global float const* restrict B, global float* restrict C) {
  for (int n = 0; n < 32 / 8; ++n) {
    float acc[8][32];

    for (int k = 0; k < 32; ++k) {
      float a_buffer[8];
      for (int nd = 0; nd < 8; ++nd) {
        a_buffer[hook(3, nd)] = A[hook(0, n * 8 * 32 + nd * 32 + k)];
      }
      for (int m = 0; m < 32; ++m) {
        float b_val = B[hook(1, k * 32 + m)];
        for (int nd = 0; nd < 8; ++nd) {
          float prev = (k > 0) ? acc[hook(5, nd)][hook(4, m)] : 0;
          acc[hook(5, nd)][hook(4, m)] = prev + a_buffer[hook(3, nd)] * b_val;
        }
      }
    }

    for (int nd = 0; nd < 8; ++nd) {
      for (int m = 0; m < 32; ++m)
        C[hook(2, n * 8 * 32 + nd * 32 + m)] = acc[hook(5, nd)][hook(4, m)];
    }
  }
}