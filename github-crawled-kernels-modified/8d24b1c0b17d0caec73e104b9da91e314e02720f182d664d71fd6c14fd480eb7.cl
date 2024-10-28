//{"Nhalf":4,"Wshift":3,"twiddle_factors":2,"vec_in":0,"vec_out":1}
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

kernel void fftstep_real2cpx(global float* vec_in, global float2* vec_out, read_only image2d_t twiddle_factors, int Wshift, int Nhalf) {
  const int src_x = get_global_id(0);
  const int k = get_global_id(1);

  const float2 twiddle_factor = read_imagef(twiddle_factors, sampler, wrap_index(k << Wshift)).xy;
  const int dest_row_idx = (k << Wshift);

  const int dest_i = dest_row_idx + src_x;
  const int src1_idx = dest_row_idx + dest_i;
  const int src2_idx = src1_idx + (1 << Wshift);

  const float2 p1 = (float2)(vec_in[hook(0, src1_idx)], 0);
  const float2 p2 = vec_in[hook(0, src2_idx)] * twiddle_factor;

  vec_out[hook(1, dest_i)] = p1 + p2;
  vec_out[hook(1, dest_i + Nhalf)] = p1 - p2;
}