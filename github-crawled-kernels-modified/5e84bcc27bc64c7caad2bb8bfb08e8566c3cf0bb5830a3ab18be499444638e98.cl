//{"out":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t imageSampler = 0 | 4 | 0x10;
const sampler_t imageSampler2 = 0 | 2 | 0x10;
kernel void operation_set(write_only image2d_t out, const float value) {
  const unsigned int X = get_global_id(0);
  const unsigned int Y = get_global_id(1);

  int2 coord_w;
  coord_w.x = X;
  coord_w.y = Y;

  write_imagef(out, coord_w, value);
}