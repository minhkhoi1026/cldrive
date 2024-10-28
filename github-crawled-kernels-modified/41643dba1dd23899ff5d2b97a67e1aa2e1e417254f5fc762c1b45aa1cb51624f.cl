//{"M":3,"buffer":0,"imageH":2,"imageW":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float random(unsigned int x, unsigned int y) {
  unsigned int a = 4421 + (1 + x) * (1 + y) + x + y;

  for (unsigned int i = 0; i < 10; i++) {
    a = ((unsigned int)1664525 * a + (unsigned int)1013904223) % (unsigned int)79197919;
  }

  float rnd = (a * 1.0f) / (79197919.f);

  return rnd - 0.5f;
}

inline int intersectBox(float4 r_o, float4 r_d, float4 boxmin, float4 boxmax, float* tnear, float* tfar) {
  float4 invR = (float4)(1.0f, 1.0f, 1.0f, 1.0f) / r_d;
  float4 tbot = invR * (boxmin - r_o);
  float4 ttop = invR * (boxmax - r_o);

  float4 tmin = min(ttop, tbot);
  float4 tmax = max(ttop, tbot);

  float largest_tmin = max(max(tmin.x, tmin.y), max(tmin.x, tmin.z));
  float smallest_tmax = min(min(tmax.x, tmax.y), min(tmax.x, tmax.z));

  *tnear = largest_tmin;
  *tfar = smallest_tmax;

  return smallest_tmax > largest_tmin;
}

inline unsigned int rgbaFloatToInt(float4 rgba) {
  rgba = clamp(rgba, (float4)(0.f, 0.f, 0.f, 0.f), (float4)(1.f, 1.f, 1.f, 1.f));

  return ((unsigned int)(rgba.w * 255) << 24) | ((unsigned int)(rgba.z * 255) << 16) | ((unsigned int)(rgba.y * 255) << 8) | (unsigned int)(rgba.x * 255);
}

inline unsigned int rgbaFloatToIntAndMax(unsigned int existing, float4 rgba) {
  rgba = clamp(rgba, (float4)(0.f, 0.f, 0.f, 0.f), (float4)(1.f, 1.f, 1.f, 1.f));

  const unsigned int nr = (unsigned int)(rgba.x * 255);
  const unsigned int ng = (unsigned int)(rgba.y * 255);
  const unsigned int nb = (unsigned int)(rgba.z * 255);
  const unsigned int na = (unsigned int)(rgba.w * 255);

  const unsigned int er = existing & 0xFF;
  const unsigned int eg = (existing >> 8) & 0xFF;
  const unsigned int eb = (existing >> 16) & 0xFF;
  const unsigned int ea = (existing >> 24) & 0xFF;

  const unsigned int r = max(nr, er);
  const unsigned int g = max(ng, eg);
  const unsigned int b = max(nb, eb);
  const unsigned int a = max(na, ea);

  return a << 24 | b << 16 | g << 8 | r;
}

float4 mult(constant float* M, float4 v) {
  float4 res;
  res.x = dot(v, (float4)(M[hook(3, 0)], M[hook(3, 1)], M[hook(3, 2)], M[hook(3, 3)]));
  res.y = dot(v, (float4)(M[hook(3, 4)], M[hook(3, 5)], M[hook(3, 6)], M[hook(3, 7)]));
  res.z = dot(v, (float4)(M[hook(3, 8)], M[hook(3, 9)], M[hook(3, 10)], M[hook(3, 11)]));
  res.w = dot(v, (float4)(M[hook(3, 12)], M[hook(3, 13)], M[hook(3, 14)], M[hook(3, 15)]));
  return res;
}

kernel void clearbuffer(global unsigned int* buffer, unsigned int imageW, unsigned int imageH) {
  const unsigned int x = get_global_id(0);
  const unsigned int y = get_global_id(1);

  if ((x < imageW) || (y < imageH))
    buffer[hook(0, x + y * imageW)] = 0;
}