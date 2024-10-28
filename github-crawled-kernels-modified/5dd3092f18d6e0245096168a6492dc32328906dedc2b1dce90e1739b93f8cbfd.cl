//{"image":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void unsafe_builtins(image2d_t image) {
  sampler_t sampler = 0x20 | 4 | 1;

  read_imagef(image, sampler, (float2)(0, 0));

  sampler_t sampler3 =

      4 / 1;
}