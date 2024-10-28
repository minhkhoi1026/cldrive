//{"K":6,"M":4,"N":5,"a":0,"b":1,"batch_size":7,"bias":2,"c":3,"cur_c":8}
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

kernel void gemm_batch_naive(global const float* a, global const float* b, global const float* bias, global float* c, const int M, const int N, const int K, const int batch_size) {
  const int row = get_global_id(0);
  const int col = get_global_id(1);
  const int bidx = get_global_id(2);

  const global float* cur_b = b + K * N * bidx;
  global float* cur_c = c + M * N * bidx;

  if ((col >= N) || (row >= M) || (bidx >= batch_size)) {
    return;
  }

  float a0, b0, c0 = (bias && col < N) ? bias[hook(2, row)] : 0;

  for (int p = 0; p < K; ++p) {
    a0 = *(a + row * K + p);
    b0 = *(cur_b + p * N + col);
    c0 += a0 * b0;
  }

  cur_c[hook(8, row * N + col)] = activation(c0);
}