//{"img_in":0,"img_out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void quantize_show(read_only image2d_t img_in, write_only image2d_t img_out) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  float4 in = read_imagef(img_in, sampler, (int2)(x, y));
  in = clamp(in, (float4)(0.0f, 0.0f, 0.0f, 0.0f), (float4)(1.0f, 1.0f, 1.0f, 1.0f));
  write_imagef(img_out, (int2)(x, y), in * 255.0f);
}