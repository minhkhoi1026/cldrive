//{"N":1,"coeffs":0,"parteFissa":2}
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

kernel void mtx_init(global float2* coeffs, int N, float parteFissa) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= N || y >= N)
    return;

  float c, s = sincos(parteFissa * x * y, &c);
  coeffs[hook(0, y * N + x)] = (float2)(c, s);
}