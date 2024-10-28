//{"N":2,"coeffs":3,"result":1,"samples":0,"temp_i":5,"temp_r":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float2 float2;
inline float cabs(float2 a) {
  return sqrt(a.x * a.x + a.y * a.y);
}

inline float2 cmult(float2 a, float2 b) {
  return (float2)(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

inline float2 cexp(float2 a) {
  return exp(a.x) * (float2)(cos(a.y), sin(a.y));
}

kernel void mtx_cpx2cpx(global float2* samples, global float2* result, int N, global float2* coeffs, local float* temp_r, local float* temp_i) {
  const int k = get_global_id(0);
  const int id = get_local_id(0);
  const int GS = get_local_size(0);

  float2 sum = (float2)(0, 0);

  for (int j_start = 0; j_start < N; j_start += GS) {
    const int j_end = min(N, j_start + GS);

    if (j_start != 0)
      barrier(0x01);

    if (j_start + id < j_end) {
      float2 v = samples[hook(0, j_start + id)];
      temp_r[hook(4, id)] = v.x;
      temp_i[hook(5, id)] = v.y;
    }
    barrier(0x01);

    if (k < N) {
      for (int j = j_start; j < j_end; j++)
        sum += cmult((float2)(temp_r[hook(4, j - j_start)], temp_i[hook(5, j - j_start)]), coeffs[hook(3, j * N + k)]);
    }
  }

  if (k < N)
    result[hook(1, k)] = sum;
}