//{"dst":2,"src1":0,"src2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void add_image(read_only image2d_t src1, read_only image2d_t src2, write_only image2d_t dst) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int width = get_image_width(src1);
  float4 src1_pixel = read_imagef(src1, sampler, (int2)(x, y));
  float4 src2_pixel = read_imagef(src2, sampler, (int2)(x, y));
  float alpha = 0.5f;

  write_imagef(dst, (int2)(x, y), ((alpha * src1_pixel) + (1 - alpha) * src2_pixel));
}