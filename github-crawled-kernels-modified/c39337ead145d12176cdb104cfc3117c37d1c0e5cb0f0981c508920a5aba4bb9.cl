//{"dst":1,"sampler":2,"srcimg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_r_uint8(read_only image2d_t srcimg, global unsigned char* dst, sampler_t sampler) {
  int tid_x = get_global_id(0);
  int tid_y = get_global_id(1);
  int indx = tid_y * get_image_width(srcimg) + tid_x;
  uint4 float3;

  float3 = read_imageui(srcimg, sampler, (int2)(tid_x, tid_y));
  dst[hook(1, indx)] = (unsigned char)(float3.x);
}