//{"twiddle_factors":0}
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

int2 wrap_index(int idx) {
  return (int2)(idx % 4096, idx / 4096);
}

kernel void fftstep_init(write_only image2d_t twiddle_factors) {
  const float arg = -2.0 * 3.14159265358979323846264338327950288f * get_global_id(0) / (2 * get_global_size(0));

  float c, s = sincos(arg, &c);
  write_imagef(twiddle_factors, wrap_index(get_global_id(0)), (float4)(c, s, 0, 0));
}