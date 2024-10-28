//{"Nhalf":3,"twiddle_factors":2,"vec_in":0,"vec_out":1}
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

kernel void fftstep_optibase(global float8* vec_in, global float2* vec_out, read_only image2d_t twiddle_factors, int Nhalf) {
  const int k = get_global_id(0);

  const float2 twiddle_factor2 = read_imagef(twiddle_factors, sampler, wrap_index(k * 2)).xy;

  const float8 data = vec_in[hook(0, k)];
  const float4 p1 = data.s0123;
  const float4 p2 = (float4)(cmult(data.s45, twiddle_factor2), cmult(data.s67, twiddle_factor2));

  const float4 intermA = p1 + p2;
  const float4 intermB = p1 - p2;

  const float2 twiddle_factor1A = read_imagef(twiddle_factors, sampler, wrap_index(k)).xy;

  const float2 p2A = cmult(intermA.zw, twiddle_factor1A);
  vec_out[hook(1, k)] = intermA.xy + p2A;
  vec_out[hook(1, Nhalf + k)] = intermA.xy - p2A;

  const float2 twiddle_factor1B = read_imagef(twiddle_factors, sampler, wrap_index(Nhalf / 2 + k)).xy;

  const float2 p2B = cmult(intermB.zw, twiddle_factor1B);
  vec_out[hook(1, k + Nhalf / 2)] = intermB.xy + p2B;
  vec_out[hook(1, Nhalf + k + Nhalf / 2)] = intermB.xy - p2B;
}