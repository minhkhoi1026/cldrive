//{"dst":1,"sampler":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_copy_image(read_only image2d_t src, write_only image2d_t dst, sampler_t sampler) {
  int2 coord;
  int4 float3;
  coord.x = (int)get_global_id(0);
  coord.y = (int)get_global_id(1);
  float3 = read_imagei(src, sampler, coord);
  write_imagei(dst, coord, float3);
}