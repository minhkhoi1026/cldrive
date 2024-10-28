//{"dst":2,"src_x":0,"src_y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void sobel_combine(read_only image2d_t src_x, read_only image2d_t src_y, write_only image2d_t dst) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  float4 c1 = read_imagef(src_x, coords);
  float4 c2 = read_imagef(src_y, coords);
  float4 res = clamp(c1 + c2, 0.0f, 1.0f);
  res.w = 1.0f;
  write_imagef(dst, coords, res);
}