//{"K":6,"M":4,"N":5,"a":0,"b":1,"bias":2,"c":3}
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

kernel void fc_gemv_naive(global const float* a, global const float* b, global const float* bias, global float* c, const int M, const int N, const int K) {
  const int col = get_global_id(0);

  if (col >= N) {
    return;
  }
  float c0 = bias ? bias[hook(2, col)] : 0;
  for (int p = 0; p < K; ++p) {
    float a0 = *(a + p);
    float b0 = *(b + p * N + col);
    c0 += a0 * b0;
  }

  c[hook(3, col)] = c0;
}