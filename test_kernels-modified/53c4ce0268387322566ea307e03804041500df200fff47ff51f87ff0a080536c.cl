//{"N":2,"coeffs":3,"result":1,"samples":0}
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

const sampler_t sampler = 0 | 0 | 0x10;

kernel void mtxtex_real2cpx(read_only image2d_t samples, global float2* result, int N, global float2* coeffs) {
  const int k = get_global_id(0);

  if (k >= N)
    return;

  float2 sum = (float2)(0, 0);

  for (int j = 0; j < N; j++)
    sum += read_imagef(samples, sampler, (int2)(0, j)).x * coeffs[hook(3, j * N + k)];

  result[hook(1, k)] = sum;
}