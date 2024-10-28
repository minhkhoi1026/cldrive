//{"dst":0,"height":4,"src":1,"src_sampler":2,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void default_kernel_image2d(write_only image2d_t dst, read_only image2d_t src, const sampler_t src_sampler, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  uint4 val = read_imageui(src, src_sampler, (int2)(x, y));
  write_imageui(dst, (int2)(x, y), val);
}