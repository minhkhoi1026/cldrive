//{"dst":3,"height":2,"src":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t nearestSampler = 0 | 2 | 0x10;
void invertrb(read_only image2d_t src, unsigned int width, unsigned int height, write_only image2d_t dst) {
  const unsigned int gx = get_global_id(0);
  const unsigned int gy = get_global_id(1);

  if ((gx >= width) || (gy >= height))
    return;

  int2 pos = (int2)(gx, gy);
  uint4 value = read_imageui(src, nearestSampler, pos);

  write_imageui(dst, pos, value.zyxw);
}

kernel void rgbtobgr(read_only image2d_t src, unsigned int width, unsigned int height, write_only image2d_t dst) {
  invertrb(src, width, height, dst);
}