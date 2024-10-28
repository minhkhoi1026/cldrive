//{"img_in_a":3,"img_in_b":2,"img_in_g":1,"img_in_r":0,"img_out":4,"in_height":6,"in_width":5,"out_height":8,"out_width":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 1 | 2 | 0x20;
kernel void run_jpg(read_only image2d_t img_in_r, read_only image2d_t img_in_g, read_only image2d_t img_in_b, read_only image2d_t img_in_a, write_only image2d_t img_out, int in_width, int in_height, int out_width, int out_height) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float2 coord = (float2)((float)x / (float)out_width, (float)y / (float)out_height);
  float4 val = 1.0f;

  val.a = read_imagef(img_in_a, sampler, coord).r;
  val.r = read_imagef(img_in_r, sampler, coord).r * val.a;
  val.g = read_imagef(img_in_g, sampler, coord).r * val.a;
  val.b = read_imagef(img_in_b, sampler, coord).r * val.a;
  write_imagef(img_out, (int2)(x, y), val);
}