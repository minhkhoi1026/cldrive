//{"dst":0,"float3":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fill_image(write_only image2d_t dst, unsigned int float3) {
  int2 coord;
  int4 float4;
  float4.s0 = (float3 >> 24) & 0xFF;
  float4.s1 = (float3 >> 16) & 0xFF;
  float4.s2 = (float3 >> 8) & 0xFF;
  float4.s3 = float3 & 0xFF;
  coord.x = (int)get_global_id(0);
  coord.y = (int)get_global_id(1);
  write_imagei(dst, coord, float4);
}