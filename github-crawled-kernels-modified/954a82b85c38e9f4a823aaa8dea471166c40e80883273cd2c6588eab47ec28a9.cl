//{"dst_uv":3,"dst_y":2,"src_height":4,"src_uv":1,"src_y":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void runtime_mirror_effect(read_only image2d_t src_y, read_only image2d_t src_uv, write_only image2d_t dst_y, write_only image2d_t dst_uv, int src_height) {
  const sampler_t sampler = 0 | 0x10;
  int2 loc = (int2)(get_global_id(0), get_global_id(1));
  uint4 color_y, color_uv;

  if (loc.y < src_height / 2) {
    color_y = read_imageui(src_y, sampler, loc);
    color_uv = read_imageui(src_uv, sampler, loc / 2);
  } else {
    int2 newloc = (int2)(loc.x, src_height - loc.y);
    color_y = read_imageui(src_y, sampler, newloc);
    color_uv = read_imageui(src_uv, sampler, newloc / 2);
  }

  write_imageui(dst_y, loc, color_y);
  write_imageui(dst_uv, loc / 2, color_uv);
}