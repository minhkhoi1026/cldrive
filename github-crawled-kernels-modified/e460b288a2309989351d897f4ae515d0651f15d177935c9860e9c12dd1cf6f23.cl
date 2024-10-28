//{"offset":0,"out":3,"resolution":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int bound(const float2 seed) {
  float2 value = seed;

  unsigned int i = 1;

  while (i < 256) {
    const float2 sqr = value * value;

    value = (float2)(sqr.x - sqr.y, 2.0F * value.x * value.y) + seed;

    if (sqr.x + sqr.y >= 4.0F)
      return i;

    i++;
  }

  return 0;
}

kernel void generate(const float2 offset, const float2 resolution, const unsigned int width, global int* out) {
  const int2 id = (int2)(get_global_id(0), get_global_id(1));

  const float2 z = offset + resolution * (float2)(id.x, id.y);

  out[hook(3, id.y * width + id.x)] = bound(z);
}