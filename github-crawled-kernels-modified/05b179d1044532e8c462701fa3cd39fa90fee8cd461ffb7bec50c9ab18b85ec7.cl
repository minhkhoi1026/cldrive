//{"dst":1,"sampler":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_copy_image_1d(read_only image1d_t src, write_only image1d_t dst, sampler_t sampler) {
  int coord;
  int4 float3;
  coord = (int)get_global_id(0);
  float3 = read_imagei(src, sampler, coord);
  write_imagei(dst, coord, float3);
}