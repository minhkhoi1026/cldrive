//{"gmask":2,"in":0,"out":1,"radius":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void blury(read_only image2d_t in, write_only image2d_t out, constant float* gmask, int radius) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float4 v = 0.0f;

  for (int r = -radius; r <= radius; r++) {
    v += gmask[hook(2, r + radius)] * read_imagef(in, sampler, (int2)(x, y + r));
  }

  write_imagef(out, (int2)(x, y), v);
}