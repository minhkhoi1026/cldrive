//{"dst":0,"resx":1,"resy":2,"w":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float2 float2;
typedef float3 float3;
typedef float4 float4;
inline float3 reflect(float3 I, float3 N) {
  return I - 2.0f * dot(N, I) * N;
}

inline float oa(float3 q) {
  return native_cos(q.x) + native_cos(q.y * 1.5f) + native_cos(q.z) + native_cos(q.y * 20.f) * .05f;
}

inline float ob(float3 q) {
  return fast_length(max(fabs(q - (float3)(native_cos(q.z * 1.5f) * .3f, -.5f + native_cos(q.z) * .2f, .0f)) - (float3)(.125f, .02f, 1.f + 3.f), (float3)(.0f)));
}

inline float o(float3 q) {
  return min(oa(q), ob(q));
}

inline __attribute__((always_inline)) float3 gn(float3 q) {
  const float3 fxyy = (float3)(.01f, 0.f, 0.f);
  const float3 fyxy = (float3)(0.f, .01f, 0.f);
  const float3 fyyx = (float3)(0.f, 0.f, .01f);
  return fast_normalize((float3)(o(q + fxyy), o(q + fyxy), o(q + fyyx)));
}

inline unsigned int pack_fp4(float4 u4) {
  unsigned int u;
  u = (((unsigned int)u4.x)) | (((unsigned int)u4.y) << 8) | (((unsigned int)u4.z) << 16);
  return u;
}

kernel void compiler_ribbon(global unsigned int* dst, float resx, float resy, int w) {
  float2 gl_FragCoord = (float2)(get_global_id(0), get_global_id(1));
  float2 p = -1.0f + 2.0f * gl_FragCoord.xy / (float2)(resx, resy);
  p.x *= resx / resy;

  float4 c = (float4)(1.0f);
  const float3 org = (float3)(native_sin(1.f) * .5f, native_cos(1.f * .5f) * .25f + .25f, 1.f);
  float3 dir = fast_normalize((float3)(p.x * 1.6f, p.y, 1.0f));
  float3 q = org, pp;
  float d = .0f;

  for (int i = 0; i < 64; i++) {
    d = o(q);
    q += d * dir;
  }
  pp = q;
  const float f = fast_length(q - org) * 0.02f;

  dir = reflect(dir, gn(q));
  q += dir;
  for (int i = 0; i < 64; i++) {
    d = o(q);
    q += d * dir;
  }
  c = max(dot(gn(q), (float3)(0.1f, 0.1f, 0.0f)), 0.0f) + (float4)(0.3f, native_cos(1.f * .5f) * .5f + .5f, native_sin(1.f * .5f) * .5f + .5f, 1.f) * min(fast_length(q - org) * .04f, 1.f);

  if (oa(pp) > ob(pp))
    c = mix(c, (float4)(native_cos(1.f * .3f) * 0.5f + 0.5f, native_cos(1.f * .2f) * .5f + .5f, native_sin(1.f * .3f) * .5f + .5f, 1.f), .3f);

  const float4 float3 = ((c + (float4)(f)) + (1.f - min(pp.y + 1.9f, 1.f)) * (float4)(1.f, .8f, .7f, 1.f)) * min(1.f * .5f, 1.f);
  const float4 final = 255.f * max(min(float3, (float4)(1.f)), (float4)(0.f));
  dst[hook(0, get_global_id(0) + get_global_id(1) * w)] = pack_fp4(final);
}