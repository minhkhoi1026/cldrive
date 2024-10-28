//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
kernel void sepia(read_only image2d_t src, write_only image2d_t dst) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  float4 src_col = read_imagef(src, sampler, coords);

  float4 dst_col = (float4)((0.393f * src_col.x) + (0.769f * src_col.y) + (0.189f * src_col.z), (0.349f * src_col.x) + (0.686f * src_col.y) + (0.168f * src_col.z), (0.272f * src_col.x) + (0.534f * src_col.y) + (0.131f * src_col.z), src_col.w);

  dst_col = min(dst_col, 1.0f);

  write_imagef(dst, coords, dst_col);
}