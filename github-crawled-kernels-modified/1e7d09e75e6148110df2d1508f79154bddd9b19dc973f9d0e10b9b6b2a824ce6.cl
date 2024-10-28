//{"h":5,"img_uv_dst":1,"img_uv_src":3,"img_y_dst":0,"img_y_src":2,"w":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transform_rot_270(write_only image2d_t img_y_dst, write_only image2d_t img_uv_dst, read_only image2d_t img_y_src, read_only image2d_t img_uv_src, unsigned int w, unsigned int h) {
  sampler_t sampler = 0 | 2 | 0x10;
  size_t g_id_x = get_global_id(0);
  size_t g_id_y = get_global_id(1);
  float4 src0, src1, src2, src3, dst;

  int coord_x = 4 * g_id_x;
  int coord_y = 4 * g_id_y;
  src0 = read_imagef(img_y_src, sampler, (int2)(g_id_x, coord_y));
  src1 = read_imagef(img_y_src, sampler, (int2)(g_id_x, coord_y + 1));
  src2 = read_imagef(img_y_src, sampler, (int2)(g_id_x, coord_y + 2));
  src3 = read_imagef(img_y_src, sampler, (int2)(g_id_x, coord_y + 3));
  dst = (float4)(src0.w, src1.w, src2.w, src3.w);
  write_imagef(img_y_dst, (int2)(g_id_y, w * 4 - coord_x), dst);
  dst = (float4)(src0.z, src1.z, src2.z, src3.z);
  write_imagef(img_y_dst, (int2)(g_id_y, w * 4 - coord_x + 1), dst);
  dst = (float4)(src0.y, src1.y, src2.y, src3.y);
  write_imagef(img_y_dst, (int2)(g_id_y, w * 4 - coord_x + 2), dst);
  dst = (float4)(src0.x, src1.x, src2.x, src3.x);
  write_imagef(img_y_dst, (int2)(g_id_y, w * 4 - coord_x + 3), dst);

  coord_x = 2 * g_id_x;
  coord_y = 2 * g_id_y;
  src0 = read_imagef(img_uv_src, sampler, (int2)(g_id_x, coord_y));
  src1 = read_imagef(img_uv_src, sampler, (int2)(g_id_x, coord_y + 1));
  dst = (float4)(src0.z, src0.w, src1.z, src1.w);
  write_imagef(img_uv_dst, (int2)(g_id_y, w * 2 - coord_x), dst);
  dst = (float4)(src0.x, src0.y, src1.x, src1.y);
  write_imagef(img_uv_dst, (int2)(g_id_y, w * 2 - coord_x + 1), dst);
}