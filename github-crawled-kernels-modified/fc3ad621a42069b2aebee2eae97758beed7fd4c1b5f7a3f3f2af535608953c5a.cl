//{"a1":0,"a2":1,"sampler":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compare_image_2d_and_1d_array(image2d_t a1, image1d_array_t a2, sampler_t sampler) {
  float2 coord;
  int4 color1;
  int4 color2;
  coord.x = (float)get_global_id(0) + 0.3f;
  coord.y = (float)get_global_id(1) + 0.3f;
  color1 = read_imagei(a1, sampler, coord);
  color2 = read_imagei(a2, sampler, coord);
}