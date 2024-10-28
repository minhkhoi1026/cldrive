//{"arg_r":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t imageSampler = 0 | 4 | 0x10;
const sampler_t imageSampler2 = 0 | 2 | 0x10;
kernel void POSC(read_only image2d_t arg_r, write_only image2d_t out) {
  const unsigned int X = get_global_id(0);
  const unsigned int Y = get_global_id(1);

  int2 coord_w;
  coord_w.x = X;
  coord_w.y = Y;

  float2 coord_r;
  coord_r.x = X + 0.5f;
  coord_r.y = Y + 0.5f;

  float value = read_imagef(arg_r, imageSampler2, coord_r).s0;
  value = value > 0 ? value : 0;
  write_imagef(out, coord_w, value);
}