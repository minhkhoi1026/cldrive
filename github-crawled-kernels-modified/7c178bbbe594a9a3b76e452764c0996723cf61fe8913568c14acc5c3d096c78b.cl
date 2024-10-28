//{"dst":0,"resx":1,"resy":2,"w":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float2 float2;
typedef float3 float3;
typedef float4 float4;
inline __attribute__((always_inline, overloadable)) float glsl_mod(float x, float y) {
  return mad(-y, floor(x / y), x);
}
inline __attribute__((always_inline, overloadable)) float2 glsl_mod(float2 a, float2 b) {
  return (float2)(glsl_mod(a.x, b.x), glsl_mod(a.y, b.y));
}
inline __attribute__((always_inline, overloadable)) float3 glsl_mod(float3 a, float3 b) {
  return (float3)(glsl_mod(a.x, b.x), glsl_mod(a.y, b.y), glsl_mod(a.z, b.z));
}

inline float3 reflect(float3 I, float3 N) {
  return I - 2.0f * dot(N, I) * N;
}

inline unsigned int pack_fp4(float4 u4) {
  unsigned int u;
  u = (((unsigned int)u4.x)) | (((unsigned int)u4.y) << 8) | (((unsigned int)u4.z) << 16);
  return u;
}

inline __attribute__((always_inline)) float maxcomp(float3 p) {
  return max(p.x, max(p.y, p.z));
}

inline __attribute__((always_inline)) float sdBox(float3 p, float3 b) {
  float3 di = fabs(p) - b;
  float mc = maxcomp(di);
  return min(mc, fast_length(max(di, 0.0f)));
}

inline __attribute__((always_inline)) float4 map(float3 p) {
  float d = sdBox(p, (float3)(1.0f));
  float4 res = (float4)(d, 1.f, 0.f, 0.f);

  float s = 1.0f;
  for (int m = 0; m < 3; m++) {
    float3 a = glsl_mod(p * s, 2.0f) - 1.0f;
    s *= 3.0f;
    float rx = fabs(1.0f - 3.0f * fabs(a.x));
    float ry = fabs(1.0f - 3.0f * fabs(a.y));
    float rz = fabs(1.0f - 3.0f * fabs(a.z));

    float da = max(rx, ry);
    float db = max(ry, rz);
    float dc = max(rz, rx);
    float c = (min(da, min(db, dc)) - 1.0f) / s;
    if (c > d) {
      d = c;
      res = (float4)(d, 0.2f * da * db * dc, (1.0f + (float)(m)) / 4.0f, 0.0f);
    }
  }
  return (float4)(res.x, res.y, res.z, 0.f);
}

inline __attribute__((always_inline)) float4 intersect(float3 ro, float3 rd) {
  float t = 0.0f;
  for (int i = 0; i < 64; i++) {
    float4 h = map(ro + rd * t);
    if (h.x < 0.002f)
      return (float4)(t, h.yzw);
    t += h.x;
  }
  return (float4)(-1.0f);
}

kernel void compiler_menger_sponge_no_shadow(global unsigned int* dst, float resx, float resy, int w) {
  float2 gl_FragCoord = (float2)(get_global_id(0), get_global_id(1));
  float2 p = -1.0f + 2.0f * gl_FragCoord.xy / (float2)(resx, resy);

  float3 light = fast_normalize((float3)(1.0f, 0.8f, -0.6f));

  float ctime = 1.f;

  float3 ro = 1.1f * (float3)(2.5f * native_cos(0.5f * ctime), 1.5f * native_cos(ctime * .23f), 2.5f * native_sin(0.5f * ctime));
  float3 ww = fast_normalize((float3)(0.0f) - ro);
  float3 uu = fast_normalize(cross((float3)(0.0f, 1.0f, 0.0f), ww));
  float3 vv = fast_normalize(cross(ww, uu));
  float3 rd = fast_normalize(p.x * uu + p.y * vv + 1.5f * ww);
  float3 col = (float3)(0.0f);
  float4 tmat = intersect(ro, rd);

  if (tmat.x > 0.0f)
    col = (float3)(0.6f + 0.4f * native_cos(5.0f + 6.2831f * tmat.z), 0.6f + 0.4f * native_cos(5.4f + 6.2831f * tmat.z), 0.6f + 0.4f * native_cos(5.7f + 6.2831f * tmat.z));

  float4 gl_FragColor = (float4)(col, 1.0f);
  do {
    const float4 final = 255.f * max(min(gl_FragColor, (float4)(1.f)), (float4)(0.f));
    dst[hook(0, get_global_id(0) + get_global_id(1) * w)] = pack_fp4(final);
  } while (0);
}