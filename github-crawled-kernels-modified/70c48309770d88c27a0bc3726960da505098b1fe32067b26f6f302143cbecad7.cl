//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t imageSampler = 0 | 4 | 0x10;
const sampler_t imageSampler2 = 0 | 2 | 0x10;
kernel void operation_inv(read_only image2d_t in, write_only image2d_t out) {
  const unsigned int X = get_global_id(0);
  const unsigned int Y = get_global_id(1);

  float2 coord_r;
  coord_r.x = (float)X + 0.5f;
  coord_r.y = (float)Y + 0.5f;

  int2 coord_w;
  coord_w.x = X;
  coord_w.y = Y;

  float value = read_imagef(in, imageSampler, coord_r).s0;
  value = (value != 0) ? 1.0f / value : 0;
  write_imagef(out, coord_w, value);
}