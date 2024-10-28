//{"dst":0,"resx":1,"resy":2,"s":4,"w":3}
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

inline unsigned int pack_fp4(float4 u4) {
  unsigned int u;
  u = (((unsigned int)u4.x)) | (((unsigned int)u4.y) << 8) | (((unsigned int)u4.z) << 16);
  return u;
}

kernel void compiler_chocolux(global unsigned int* dst, float resx, float resy, int w) {
  float2 gl_FragCoord = (float2)(get_global_id(0), get_global_id(1));
  float3 s[4];
  s[hook(4, 0)] = (float3)(0);
  s[hook(4, 3)] = (float3)(native_sin(10.f), native_cos(10.f), 0);
  s[hook(4, 1)] = s[hook(4, 3)].zxy;
  s[hook(4, 2)] = s[hook(4, 3)].zzx;

  float t, b, c, h = 0.0f;
  float3 m, n;
  float3 p = (float3)(.2f);
  float3 d = fast_normalize(.001f * (float3)(gl_FragCoord, .0f) - p);

  for (int i = 0; i < 4; i++) {
    t = 2.0f;
    for (int i = 0; i < 4; i++) {
      b = dot(d, n = s[hook(4, i)] - p);
      c = b * b + .2f - dot(n, n);
      if (b - c < t)
        if (c > 0.0f) {
          m = s[hook(4, i)];
          t = b - c;
        }
    }
    p += t * d;
    d = reflect(d, n = fast_normalize(p - m));
    h += pow(n.x * n.x, 44.f) + n.x * n.x * .2f;
  }
  float4 gl_FragColor = (float4)(h, h * h, h * h * h * h, 1.f);
  do {
    const float4 final = 255.f * max(min(gl_FragColor, (float4)(1.f)), (float4)(0.f));
    dst[hook(0, get_global_id(0) + get_global_id(1) * w)] = pack_fp4(final);
  } while (0);
}