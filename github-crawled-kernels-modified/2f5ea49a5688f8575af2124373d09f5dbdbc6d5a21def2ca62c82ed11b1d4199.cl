//{"bg_uv":3,"bg_y":2,"crop_h":8,"crop_w":7,"crop_x":5,"crop_y":6,"dst_uv":1,"dst_y":0,"fg":4,"rgba":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blend(write_only image2d_t dst_y, write_only image2d_t dst_uv, read_only image2d_t bg_y, read_only image2d_t bg_uv, read_only image2d_t fg, unsigned int crop_x, unsigned int crop_y, unsigned int crop_w, unsigned int crop_h) {
  sampler_t sampler = 0 | 2 | 0x10;
  int i;
  int id_x = get_global_id(0);
  int id_y = get_global_id(1) * 2;
  int id_z = id_x;
  int id_w = id_y;

  float4 y1, y2;
  float4 y1_dst, y2_dst, y_dst;
  float4 uv, uv_dst;
  float4 rgba[4];

  id_x += crop_x;
  id_y += crop_y;
  y1 = read_imagef(bg_y, sampler, (int2)(id_x, id_y));
  y2 = read_imagef(bg_y, sampler, (int2)(id_x, id_y + 1));
  uv = read_imagef(bg_uv, sampler, (int2)(id_x, id_y / 2));

  rgba[hook(9, 0)] = read_imagef(fg, sampler, (int2)(2 * id_z, id_w));
  rgba[hook(9, 1)] = read_imagef(fg, sampler, (int2)(2 * id_z + 1, id_w));
  rgba[hook(9, 2)] = read_imagef(fg, sampler, (int2)(2 * id_z, id_w + 1));
  rgba[hook(9, 3)] = read_imagef(fg, sampler, (int2)(2 * id_z + 1, id_w + 1));

  y_dst = 0.299f * (float4)(rgba[hook(9, 0)].x, rgba[hook(9, 1)].x, rgba[hook(9, 2)].x, rgba[hook(9, 3)].x);
  y_dst = mad(0.587f, (float4)(rgba[hook(9, 0)].y, rgba[hook(9, 1)].y, rgba[hook(9, 2)].y, rgba[hook(9, 3)].y), y_dst);
  y_dst = mad(0.114f, (float4)(rgba[hook(9, 0)].z, rgba[hook(9, 1)].z, rgba[hook(9, 2)].z, rgba[hook(9, 3)].z), y_dst);
  y_dst *= (float4)(rgba[hook(9, 0)].w, rgba[hook(9, 1)].w, rgba[hook(9, 2)].w, rgba[hook(9, 3)].w);
  y1_dst.x = mad(1 - rgba[hook(9, 0)].w, y1.x, y_dst.x);
  y1_dst.y = mad(1 - rgba[hook(9, 1)].w, y1.y, y_dst.y);
  y2_dst.x = mad(1 - rgba[hook(9, 2)].w, y2.x, y_dst.z);
  y2_dst.y = mad(1 - rgba[hook(9, 3)].w, y2.y, y_dst.w);

  uv_dst.x = rgba[hook(9, 0)].w * (-0.14713f * rgba[hook(9, 0)].x - 0.28886f * rgba[hook(9, 0)].y + 0.43600f * rgba[hook(9, 0)].z + 0.5f);
  uv_dst.y = rgba[hook(9, 0)].w * (0.61500f * rgba[hook(9, 0)].x - 0.51499f * rgba[hook(9, 0)].y - 0.10001f * rgba[hook(9, 0)].z + 0.5f);
  uv_dst.x = mad(1 - rgba[hook(9, 0)].w, uv.x, uv_dst.x);
  uv_dst.y = mad(1 - rgba[hook(9, 0)].w, uv.y, uv_dst.y);

  if (id_z <= crop_w && id_w <= crop_h) {
    write_imagef(dst_y, (int2)(id_x, id_y), y1_dst);
    write_imagef(dst_y, (int2)(id_x, id_y + 1), y2_dst);
    write_imagef(dst_uv, (int2)(id_x, id_y / 2), uv_dst);
  }
}