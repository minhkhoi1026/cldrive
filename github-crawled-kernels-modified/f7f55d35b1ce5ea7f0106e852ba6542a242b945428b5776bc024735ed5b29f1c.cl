//{"P":5,"U4_in":0,"U4_out":1,"buffer":6,"height":3,"q":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float fast_mexp2f(const float x) {
  const float i1 = (float)0x3f800000u;
  const float i2 = (float)0x3f000000u;
  const float k0 = i1 + x * (i2 - i1);
  union {
    float f;
    unsigned int i;
  } k;
  k.i = (k0 >= (float)0x800000u) ? k0 : 0;
  return k.f;
}

float gh(const float f, const float sharpness) {
  return fast_mexp2f(f * sharpness);
}

float ddirac(const int2 q) {
  return ((q.x || q.y) ? 1.0f : 0.0f);
}

kernel void nlmeans_horiz(global float* U4_in, global float* U4_out, const int width, const int height, const int2 q, const int P, local float* buffer) {
  const int lid = get_local_id(0);
  const int lsz = get_local_size(0);
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int gidx = mad24(min(y, height - 1), width, min(x, width - 1));

  if (y < height) {
    buffer[hook(6, P + lid)] = U4_in[hook(0, gidx)];

    for (int n = 0; n <= P / lsz; n++) {
      const int l = mad24(n, lsz, lid + 1);
      if (l > P)
        continue;
      int xx = mad24((int)get_group_id(0), lsz, -l);
      xx = max(xx, 0);
      buffer[hook(6, P - l)] = U4_in[hook(0, mad24(y, width, xx))];
    }

    for (int n = 0; n <= P / lsz; n++) {
      const int r = mad24(n, lsz, lsz - lid);
      if (r > P)
        continue;
      int xx = mad24((int)get_group_id(0), lsz, lsz - 1 + r);
      xx = min(xx, width - 1);
      buffer[hook(6, P + lsz - 1 + r)] = U4_in[hook(0, mad24(y, width, xx))];
    }
  }

  barrier(0x01);

  if (x >= width || y >= height)
    return;

  buffer += lid + P;

  float distacc = 0.0f;
  for (int pi = -P; pi <= P; pi++) {
    distacc += buffer[hook(6, pi)];
  }

  U4_out[hook(1, gidx)] = distacc;
}