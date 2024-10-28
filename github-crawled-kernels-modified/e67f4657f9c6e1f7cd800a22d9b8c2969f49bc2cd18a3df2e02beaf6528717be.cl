//{"g1":0,"g2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void dog(read_only image2d_t g1, read_only image2d_t g2, write_only image2d_t out) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float4 v = read_imagef(g2, sampler, (int2)(x, y)) - read_imagef(g1, sampler, (int2)(x, y));

  write_imagef(out, (int2)(x, y), v);
}