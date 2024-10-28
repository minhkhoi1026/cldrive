//{"dir":2,"dst":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose(write_only image2d_t dst, read_only image2d_t src, int dir) {
  const sampler_t sampler = (0 | 2 | 0x10);

  int2 size = get_image_dim(dst);
  int x = get_global_id(0);
  int y = get_global_id(1);

  int xin = (dir & 2) ? (size.y - 1 - y) : y;
  int yin = (dir & 1) ? (size.x - 1 - x) : x;
  float4 data = read_imagef(src, sampler, (int2)(xin, yin));

  if (x < size.x && y < size.y)
    write_imagef(dst, (int2)(x, y), data);
}