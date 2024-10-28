//{"fl":3,"height":2,"sigma_r":6,"sigma_s":5,"src":0,"vmap":4,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void measurement_vertices(global const ushort* src, global const int* width, global const int* height, global const float* fl, global float3* vmap, global const float* sigma_s, global const float* sigma_r) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const float s = *sigma_s;
  const float r = *sigma_r;

  const int radius = 8;
  int w = *width;
  int h = *height;
  float focal_length = *fl;

  int tlx = max(x - radius, 0);
  int tly = max(y - radius, 0);
  int brx = min(x + radius, w);
  int bry = min(y + radius, h);

  int idx = w * y + x;

  float sum = 0;
  float wp = 0;

  float src_depth = src[hook(0, idx)];

  float s2 = s * s;
  float r2 = r * r;

  if (src_depth != 0) {
    for (int i = tlx; i < brx; i++) {
      for (int j = tly; j < bry; j++) {
        float delta_dist = (float)((x - i) * (x - i) + (y - j) * (y - j));

        int idx2 = w * j + i;
        float d = src[hook(0, idx2)];
        float delta_depth = (src_depth - d) * (src_depth - d);
        float weight = native_exp(-(delta_dist / s2 + delta_depth / r2));
        sum += weight * d;
        wp += weight;
      }
    }
    float res = sum / wp;

    vmap[hook(4, idx)].x = res * (x - w / 2) / focal_length;
    vmap[hook(4, idx)].y = res * (y - h / 2) / focal_length;
    vmap[hook(4, idx)].z = res;

  } else {
    vmap[hook(4, idx)].x = __builtin_astype((2147483647), float);
    vmap[hook(4, idx)].y = __builtin_astype((2147483647), float);
    vmap[hook(4, idx)].z = __builtin_astype((2147483647), float);
  }
}