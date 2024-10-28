//{"pconfig_dst":2,"pconfig_src":0,"pconfig_src2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void OverLap(read_only image2d_t pconfig_src, read_only image2d_t pconfig_src2, write_only image2d_t pconfig_dst) {
  const int ix = get_global_id(0);
  const int iy = get_global_id(1);
  int2 locate;
  locate.x = ix;
  locate.y = iy;
  uint4 color_src;
  uint4 color_dst;
  const sampler_t sampler = 0;
  color_src = read_imageui(pconfig_src, sampler, locate);
  color_dst = read_imageui(pconfig_src2, sampler, locate);
  write_imageui(pconfig_dst, locate, color_src + color_dst);

  return;
}