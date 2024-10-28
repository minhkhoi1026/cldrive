//{"h":4,"img_uv_dst":1,"img_uv_src":3,"img_y_dst":0,"img_y_src":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transform_flip_v(write_only image2d_t img_y_dst, write_only image2d_t img_uv_dst, read_only image2d_t img_y_src, read_only image2d_t img_uv_src, unsigned int h) {
  sampler_t sampler = 0 | 2 | 0x10;
  size_t g_id_x = get_global_id(0);
  size_t g_id_y = get_global_id(1);
  float4 data;

  int coord_y = 2 * g_id_y;
  data = read_imagef(img_y_src, sampler, (int2)(g_id_x, coord_y));
  write_imagef(img_y_dst, (int2)(g_id_x, h - 1 - coord_y), data);
  data = read_imagef(img_y_src, sampler, (int2)(g_id_x, coord_y + 1));
  write_imagef(img_y_dst, (int2)(g_id_x, h - 1 - coord_y - 1), data);

  data = read_imagef(img_uv_src, sampler, (int2)(g_id_x, g_id_y));
  write_imagef(img_uv_dst, (int2)(g_id_x, h / 2 - g_id_y), data);
}