//{"image":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image2buf_GL_R(read_only image2d_t image, global float* output) {
  const sampler_t sampler = 0 | 2 | 0x10;

  int2 coords = (int2){get_global_id(0), get_global_id(1)};
  int2 image_dim = get_image_dim(image);

  float4 colors = read_imagef(image, sampler, coords);
  output[hook(1, coords.s1 * image_dim.s0 + coords.s0)] = colors.s0;
}