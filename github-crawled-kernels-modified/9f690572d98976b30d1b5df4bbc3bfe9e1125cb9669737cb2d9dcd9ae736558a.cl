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

inline unsigned int pack_fp4(float4 u4) {
  unsigned int u;
  u = (((unsigned int)u4.x)) | (((unsigned int)u4.y) << 8) | (((unsigned int)u4.z) << 16);
  return u;
}

inline float e(float3 c) {
  c = native_cos((float3)(native_cos(c.x + 1.f / 6.0f) * c.x - native_cos(c.y * 3.0f + 1.f / 5.0f) * c.y, native_cos(1.f / 4.0f) * c.z / 3.0f * c.x - native_cos(1.f / 7.0f) * c.y, c.x + c.y + c.z + 1.f));
  return dot(c * c, (float3)(1.0f)) - 1.0f;
}

kernel void compiler_nautilus(global unsigned int* dst, float resx, float resy, int w) {
  float2 gl_FragCoord = (float2)(get_global_id(0), get_global_id(1));
  float2 c = -1.0f + 2.0f * gl_FragCoord.xy / (float2)(resx, resy);
  float3 o = (float3)(c.x, c.y, 0.0f), g = (float3)(c.x, c.y, 1.0f) / 64.0f, v = (float3)(0.5f);
  float m = 0.4f;

  for (int r = 0; r < 100; r++) {
    float h = e(o) - m;
    if (h < 0.0f)
      break;
    o += h * 10.0f * g;
    v += h * 0.02f;
  }

  v += e(o + 0.1f) * (float3)(0.4f, 0.7f, 1.0f);

  float a = 0.0f;
  for (int q = 0; q < 100; q++) {
    float l = e(o + 0.5f * (float3)(native_cos(1.1f * (float)(q)), native_cos(1.6f * (float)(q)), native_cos(1.4f * (float)(q)))) - m;
    a += floor(clamp(4.0f * l, 0.0f, 1.0f));
  }
  v *= a / 100.0f;
  float4 gl_FragColor = (float4)(v, 1.0f);
  do {
    const float4 final = 255.f * max(min(gl_FragColor, (float4)(1.f)), (float4)(0.f));
    dst[hook(0, get_global_id(0) + get_global_id(1) * w)] = pack_fp4(final);
  } while (0);
}