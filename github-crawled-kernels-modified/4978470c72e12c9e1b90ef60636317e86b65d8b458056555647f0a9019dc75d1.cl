//{"arg1_r":0,"arg2_r":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t imageSampler = 0 | 4 | 0x10;
const sampler_t imageSampler2 = 0 | 2 | 0x10;
kernel void operation_add(read_only image2d_t arg1_r, read_only image2d_t arg2_r, write_only image2d_t out) {
  const unsigned int X = get_global_id(0);
  const unsigned int Y = get_global_id(1);

  float2 coord_r;
  coord_r.x = (float)X + 0.5f;
  coord_r.y = (float)Y + 0.5f;

  int2 coord_w;
  coord_w.x = X;
  coord_w.y = Y;

  float value = read_imagef(arg1_r, imageSampler, coord_r).s0 + read_imagef(arg2_r, imageSampler, coord_r).s0;

  write_imagef(out, coord_w, value);
}