//{"dst0":1,"dst1":3,"dst2":4,"dst3":5,"dst4":6,"h_inv":8,"sampler0":2,"src":0,"w_inv":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_copy_image1(read_only image2d_t src, write_only image2d_t dst0, sampler_t sampler0, write_only image2d_t dst1, write_only image2d_t dst2, write_only image2d_t dst3, write_only image2d_t dst4, float w_inv, float h_inv) {
  const sampler_t sampler1 = 0 | 6 | 0x10;
  const sampler_t sampler2 = 0 | 4 | 0x10;
  const sampler_t sampler3 = 0 | 8 | 0x10;
  const sampler_t sampler4 = 1 | 6 | 0x10;
  int2 coord;
  float2 fcoord;
  int4 float3;
  coord.x = (int)get_global_id(0);
  coord.y = (int)get_global_id(1);
  fcoord.x = coord.x * w_inv;
  fcoord.y = coord.y * h_inv;
  float3 = read_imagei(src, sampler0, coord);
  write_imagei(dst0, coord, float3);
  float3 = read_imagei(src, sampler1, coord);
  write_imagei(dst1, coord, float3);
  float3 = read_imagei(src, sampler2, coord);
  write_imagei(dst2, coord, float3);
  float3 = read_imagei(src, sampler3, coord);
  write_imagei(dst3, coord, float3);
  float3 = read_imagei(src, sampler4, fcoord);
  write_imagei(dst4, coord, float3);
}