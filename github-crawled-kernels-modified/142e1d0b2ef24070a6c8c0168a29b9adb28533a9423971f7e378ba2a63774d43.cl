//{"g":7,"iterations":3,"out":0,"scale":4,"seed":5,"u":6,"x_0":1,"y_0":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 philox(uint2 st, unsigned int k) {
  ulong p;
  int i;

  for (i = 0; i < 3; i += 1) {
    p = st.x * 0xcd9e8d57ul;

    st.x = ((unsigned int)(p >> 32)) ^ st.y ^ k;
    st.y = (unsigned int)p;

    k += 0x9e3779b9u;
  }

  return convert_float2(st) / 2147483648.0f - 1.0f;
}

kernel void kernel_noise(global float* out, const int x_0, const int y_0, const unsigned int iterations, const float scale, const unsigned int seed) {
  const int gidx = get_global_id(0);
  const int gidy = get_global_id(1);

  float c, d, m;
  float2 p;
  int j;

  for (j = 0, m = 0, c = 1, d = scale; j < iterations; c *= 2, d *= 2, j += 1) {
    float s, t, n;
    float2 g[3], u[3], i, di;
    int k;

    p = (float2)(gidx + x_0, gidy + y_0) * d;

    s = (p.x + p.y) * (sqrt(3.0f) - 1) / 2;
    i = floor(p + s);

    s = (i.x + i.y) * (3 - sqrt(3.0f)) / 6;
    u[hook(6, 0)] = p - i + s;

    di = u[hook(6, 0)].x >= u[hook(6, 0)].y ? (float2)(1, 0) : (float2)(0, 1);

    u[hook(6, 1)] = u[hook(6, 0)] - di + (3 - sqrt(3.0f)) / 6;
    u[hook(6, 2)] = u[hook(6, 0)] - 1 + (3 - sqrt(3.0f)) / 3;

    g[hook(7, 0)] = philox(convert_uint2(convert_int2(i)), seed);
    g[hook(7, 1)] = philox(convert_uint2(convert_int2(i + di)), seed);
    g[hook(7, 2)] = philox(convert_uint2(convert_int2(i + 1)), seed);

    for (k = 0, n = 0; k < 3; k += 1) {
      t = 0.5f - dot(u[hook(6, k)], u[hook(6, k)]);

      if (t > 0) {
        t *= t;
        n += t * t * dot(g[hook(7, k)], u[hook(6, k)]);
      }
    }

    m += 70 * n / c;
  }

  out[hook(0, gidy * get_global_size(0) + gidx)] = m;
}