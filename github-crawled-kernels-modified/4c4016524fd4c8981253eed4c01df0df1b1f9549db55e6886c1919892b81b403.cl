//{"dst":0,"height":4,"src":1,"src_sampler":2,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
;
kernel void imrotate(write_only image2d_t dst, read_only image2d_t src, const sampler_t src_sampler, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  int x2 = 0, y2 = 0;
  float a = -0.4;

  float fx = x, fy = y;

  x2 = fx * cos(a) + fy * sin(a);
  y2 = -fx * sin(a) + fy * cos(a);

  uint4 val = read_imageui(src, src_sampler, (int2)(x2, y2));
  write_imageui(dst, (int2)(x, y), val);
}