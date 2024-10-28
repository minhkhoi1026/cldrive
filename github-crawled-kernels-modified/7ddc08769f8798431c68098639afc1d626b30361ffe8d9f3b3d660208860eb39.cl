//{"outputValueArray":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
kernel void samplerTypes(read_only image2d_t src, global int* outputValueArray) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  unsigned int red = read_imageui(src, sampler, (int2)(x, y)).x;
  int i = y * get_image_width(src) + x;
  outputValueArray[hook(1, i)] = red;
}