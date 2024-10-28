//{"bg_uv":3,"bg_y":2,"dst_uv":1,"dst_y":0,"fg":4,"rgba":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blend(write_only image2d_t dst_y, write_only image2d_t dst_uv, read_only image2d_t bg_y, read_only image2d_t bg_uv, read_only image2d_t fg) {
  sampler_t sampler = 0 | 2 | 0x10;
  int i;
  int id_x = get_global_id(0);
  int id_y = get_global_id(1) * 2;
  int id_z = id_x * 4;

  float4 y1, y2, uv;
  float4 y1_dst, y2_dst, uv_dst;
  float4 rgba[8], alpha1, alpha2;

  y1 = read_imagef(bg_y, sampler, (int2)(id_x, id_y));
  y2 = read_imagef(bg_y, sampler, (int2)(id_x, id_y + 1));
  uv = read_imagef(bg_uv, sampler, (int2)(id_x, id_y / 2));

  rgba[hook(5, 0)] = read_imagef(fg, sampler, (int2)(id_z, id_y));
  rgba[hook(5, 1)] = read_imagef(fg, sampler, (int2)(id_z + 1, id_y));
  rgba[hook(5, 2)] = read_imagef(fg, sampler, (int2)(id_z + 2, id_y));
  rgba[hook(5, 3)] = read_imagef(fg, sampler, (int2)(id_z + 3, id_y));
  rgba[hook(5, 4)] = read_imagef(fg, sampler, (int2)(id_z, id_y + 1));
  rgba[hook(5, 5)] = read_imagef(fg, sampler, (int2)(id_z + 1, id_y + 1));
  rgba[hook(5, 6)] = read_imagef(fg, sampler, (int2)(id_z + 2, id_y + 1));
  rgba[hook(5, 7)] = read_imagef(fg, sampler, (int2)(id_z + 3, id_y + 1));

  alpha1 = (float4)(rgba[hook(5, 0)].w, rgba[hook(5, 1)].w, rgba[hook(5, 2)].w, rgba[hook(5, 3)].w);
  alpha2 = (float4)(rgba[hook(5, 4)].w, rgba[hook(5, 5)].w, rgba[hook(5, 6)].w, rgba[hook(5, 7)].w);

  y1_dst.x = (0.29900 * rgba[hook(5, 0)].x + 0.58700 * rgba[hook(5, 0)].y + 0.11400 * rgba[hook(5, 0)].z);
  y1_dst.y = (0.29900 * rgba[hook(5, 1)].x + 0.58700 * rgba[hook(5, 1)].y + 0.11400 * rgba[hook(5, 1)].z);
  y1_dst.z = (0.29900 * rgba[hook(5, 2)].x + 0.58700 * rgba[hook(5, 2)].y + 0.11400 * rgba[hook(5, 2)].z);
  y1_dst.w = (0.29900 * rgba[hook(5, 3)].x + 0.58700 * rgba[hook(5, 3)].y + 0.11400 * rgba[hook(5, 3)].z);
  y1_dst = alpha1 * y1_dst + (1 - alpha1) * y1;
  y2_dst.x = (0.29900 * rgba[hook(5, 4)].x + 0.58700 * rgba[hook(5, 4)].y + 0.11400 * rgba[hook(5, 4)].z);
  y2_dst.y = (0.29900 * rgba[hook(5, 5)].x + 0.58700 * rgba[hook(5, 5)].y + 0.11400 * rgba[hook(5, 5)].z);
  y2_dst.z = (0.29900 * rgba[hook(5, 6)].x + 0.58700 * rgba[hook(5, 6)].y + 0.11400 * rgba[hook(5, 6)].z);
  y2_dst.w = (0.29900 * rgba[hook(5, 7)].x + 0.58700 * rgba[hook(5, 7)].y + 0.11400 * rgba[hook(5, 7)].z);
  y2_dst = alpha2 * y2_dst + (1 - alpha2) * y2;

  uv_dst.x = (-0.14713 * rgba[hook(5, 0)].x - 0.28886 * rgba[hook(5, 0)].y + 0.43600 * rgba[hook(5, 0)].z + 0.5) * alpha1.x;
  uv_dst.y = (0.61500 * rgba[hook(5, 0)].x - 0.51499 * rgba[hook(5, 0)].y - 0.10001 * rgba[hook(5, 0)].z + 0.5) * alpha1.x;
  uv_dst.z = (-0.14713 * rgba[hook(5, 2)].x - 0.28886 * rgba[hook(5, 2)].y + 0.43600 * rgba[hook(5, 2)].z + 0.5) * alpha1.z;
  uv_dst.w = (0.61500 * rgba[hook(5, 2)].x - 0.51499 * rgba[hook(5, 2)].y - 0.10001 * rgba[hook(5, 2)].z + 0.5) * alpha1.z;
  uv_dst.x += (1 - alpha1.x) * uv.x;
  uv_dst.y += (1 - alpha1.x) * uv.y;
  uv_dst.z += (1 - alpha1.z) * uv.z;
  uv_dst.w += (1 - alpha1.z) * uv.w;

  write_imagef(dst_y, (int2)(id_x, id_y), y1_dst);
  write_imagef(dst_y, (int2)(id_x, id_y + 1), y2_dst);
  write_imagef(dst_uv, (int2)(id_x, id_y / 2), uv_dst);
}