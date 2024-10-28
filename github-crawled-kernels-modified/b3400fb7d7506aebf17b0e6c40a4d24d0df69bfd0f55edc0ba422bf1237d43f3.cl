//{"K":5,"M":3,"N":4,"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float activation(float in) {
  float output = in;
  return output;
}

inline float4 activation_type4(float4 in

) {
  float4 output = in;
  return output;
}
kernel void mat_mul(global const float* a, global const float* b, global float* c, const int M, const int N, const int K) {
  const int row = get_global_id(0) << 2;
  const int col = get_global_id(1) << 2;

  if (row + 3 < M && col + 3 < N) {
    float c00 = 0, c01 = 0, c02 = 0, c03 = 0, c10 = 0, c11 = 0, c12 = 0, c13 = 0, c20 = 0, c21 = 0, c22 = 0, c23 = 0, c30 = 0, c31 = 0, c32 = 0, c33 = 0;

    for (int p = 0; p < K; p++) {
      float a00 = *(a + row * K + p), a10 = *(a + (row + 1) * K + p), a20 = *(a + (row + 2) * K + p), a30 = *(a + (row + 3) * K + p),

            b00 = *(b + p * N + col), b01 = *(b + p * N + (col + 1)), b02 = *(b + p * N + (col + 2)), b03 = *(b + p * N + (col + 3));

      c00 += a00 * b00;
      c01 += a00 * b01;
      c02 += a00 * b02;
      c03 += a00 * b03;
      c10 += a10 * b00;
      c11 += a10 * b01;
      c12 += a10 * b02;
      c13 += a10 * b03;
      c20 += a20 * b00;
      c21 += a20 * b01;
      c22 += a20 * b02;
      c23 += a20 * b03;
      c30 += a30 * b00;
      c31 += a30 * b01;
      c32 += a30 * b02;
      c33 += a30 * b03;
    }
    c[hook(2, row * N + col)] = c00;
    c[hook(2, row * N + (col + 1))] = c01;
    c[hook(2, row * N + (col + 2))] = c02;
    c[hook(2, row * N + (col + 3))] = c03;
    c[hook(2, (row + 1) * N + col)] = c10;
    c[hook(2, (row + 1) * N + (col + 1))] = c11;
    c[hook(2, (row + 1) * N + (col + 2))] = c12;
    c[hook(2, (row + 1) * N + (col + 3))] = c13;
    c[hook(2, (row + 2) * N + col)] = c20;
    c[hook(2, (row + 2) * N + (col + 1))] = c21;
    c[hook(2, (row + 2) * N + (col + 2))] = c22;
    c[hook(2, (row + 2) * N + (col + 3))] = c23;
    c[hook(2, (row + 3) * N + col)] = c30;
    c[hook(2, (row + 3) * N + (col + 1))] = c31;
    c[hook(2, (row + 3) * N + (col + 2))] = c32;
    c[hook(2, (row + 3) * N + (col + 3))] = c33;
  } else {
    for (int cidx = col; cidx < N; ++cidx) {
      for (int ridx = row; ridx < M; ++ridx) {
        float a0, b0, c0 = 0;
        for (int p = 0; p < K; ++p) {
          a0 = *(a + ridx * K + p);
          b0 = *(b + p * N + cidx), c0 += a0 * b0;
        }
        c[hook(2, ridx * N + cidx)] = c0;
      }
    }
  }
}