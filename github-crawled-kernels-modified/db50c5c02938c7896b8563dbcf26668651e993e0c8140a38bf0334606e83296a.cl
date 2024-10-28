//{"M":21,"alpha_blending":7,"boxMax_x":13,"boxMax_y":15,"boxMax_z":17,"boxMin_x":12,"boxMin_y":14,"boxMin_z":16,"brightness":3,"clear":11,"d_output":0,"dithering":9,"gamma":6,"imageH":2,"imageW":1,"invM":19,"invP":18,"maxsteps":8,"phase":10,"trangemax":5,"trangemin":4,"volume":20}
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
  res.x = dot(v, (float4)(M[hook(21, 0)], M[hook(21, 1)], M[hook(21, 2)], M[hook(21, 3)]));
  res.y = dot(v, (float4)(M[hook(21, 4)], M[hook(21, 5)], M[hook(21, 6)], M[hook(21, 7)]));
  res.z = dot(v, (float4)(M[hook(21, 8)], M[hook(21, 9)], M[hook(21, 10)], M[hook(21, 11)]));
  res.w = dot(v, (float4)(M[hook(21, 12)], M[hook(21, 13)], M[hook(21, 14)], M[hook(21, 15)]));
  return res;
}

kernel void dummy_render(global float4* d_output, const unsigned int imageW, const unsigned int imageH, const float brightness, const float trangemin, const float trangemax, const float gamma, const float alpha_blending, const int maxsteps, const float dithering, const float phase, const int clear, const float boxMin_x, const float boxMax_x, const float boxMin_y, const float boxMax_y, const float boxMin_z, const float boxMax_z, constant float* invP, constant float* invM, read_only image3d_t volume) {
  const unsigned int x = get_global_id(0);
  const unsigned int y = get_global_id(1);

  d_output[hook(0, x + y * imageW)] = (float4)(0.0f, 0.0f, 1.0f, 1.0f);
}