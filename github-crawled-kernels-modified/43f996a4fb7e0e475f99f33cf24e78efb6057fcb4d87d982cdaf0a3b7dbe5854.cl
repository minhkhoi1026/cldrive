//{"float3":1,"img":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fill_gl_image(write_only image2d_t img, int float3) {
  int2 coord;
  float4 color_v4;
  coord.x = get_global_id(0);
  coord.y = get_global_id(1);
  color_v4 = (float4){((float3 >> 24) & 0xFF), (float3 >> 16) & 0xFF, (float3 >> 8) & 0xFF, float3 & 0xFF};
  color_v4 = color_v4 / 255.0f;
  write_imagef(img, coord, color_v4);
}