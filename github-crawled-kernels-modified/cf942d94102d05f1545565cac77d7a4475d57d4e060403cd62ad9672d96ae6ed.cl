//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void downx(read_only image2d_t in, write_only image2d_t out) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float4 v = read_imagef(in, sampler, (int2)(2 * x - 1, y)) + 3.0f * read_imagef(in, sampler, (int2)(2 * x, y)) + read_imagef(in, sampler, (int2)(2 * x + 1, y)) + read_imagef(in, sampler, (int2)(2 * x + 2, y));

  write_imagef(out, (int2)(x, y), v / 8.0f);
}