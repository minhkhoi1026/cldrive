//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void gray(read_only image2d_t in, write_only image2d_t out) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float4 v = read_imagef(in, sampler, (int2)(x, y));
  float g = 0.299f * v.x + 0.587f * v.y + 0.114f * v.z;

  write_imagef(out, (int2)(x, y), (float4)(g));
}