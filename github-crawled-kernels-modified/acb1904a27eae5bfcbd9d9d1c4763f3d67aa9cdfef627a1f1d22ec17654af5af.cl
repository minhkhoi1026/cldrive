//{"blendmap":6,"ce":2,"ecc":0,"lmap":7,"n":1,"nl":3,"resmap":5,"var":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float _distance_2_point(float x, float y, float rx, float ry, float sw, float sh, float ez, float ex, float ey) {
  float dx = x / rx * sw - sw / 2.0f + ex;
  float dy = y / ry * sh - sh / 2.0f - ey;
  return sqrt(ez * ez + dx * dx + dy * dy);
}

kernel void resmap(global float* ecc, unsigned int n, constant float* ce, unsigned int nl, constant float* var, global float* resmap, global float* blendmap, global unsigned int* lmap) {
  unsigned int i = get_global_id(0);
  unsigned int l;
  for (l = 0; l <= nl; l++) {
    if (ecc[hook(0, i)] >= ce[hook(2, l)] && ecc[hook(0, i)] < ce[hook(2, l + 1)])
      break;
  }
  if (l == 0) {
    resmap[hook(5, i)] = 1.0f;
    blendmap[hook(6, i)] = 1.0f;
    lmap[hook(7, i)] = 1;
  } else if (l == nl) {
    resmap[hook(5, i)] = 1.0f / (1 << (nl - 1));
    blendmap[hook(6, i)] = 0.0f;
    lmap[hook(7, i)] = nl - 1;
  } else {
    float hres = 1.0f / (1 << (l - 1));
    float lres = 1.0f / (1 << l);
    resmap[hook(5, i)] = (lres * (ecc[hook(0, i)] - ce[hook(2, l)]) + hres * (ce[hook(2, l + 1)] - ecc[hook(0, i)])) / (ce[hook(2, l + 1)] - ce[hook(2, l)]);
    float t1 = exp(-resmap[hook(5, i)] * resmap[hook(5, i)] / (2.0f * var[hook(4, l)] * var[hook(4, l)]));
    float t2 = exp(-resmap[hook(5, i)] * resmap[hook(5, i)] / (2.0f * var[hook(4, l - 1)] * var[hook(4, l - 1)]));
    blendmap[hook(6, i)] = (0.5f - t1) / (t2 - t1);
    if (blendmap[hook(6, i)] < 0)
      blendmap[hook(6, i)] = 0.0f;
    if (blendmap[hook(6, i)] > 1)
      blendmap[hook(6, i)] = 1.0f;
    lmap[hook(7, i)] = l;
  }
}