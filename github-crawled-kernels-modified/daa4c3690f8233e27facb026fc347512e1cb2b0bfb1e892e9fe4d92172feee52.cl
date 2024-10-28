//{"img_in_0":0,"img_in_1":1,"img_out":2,"out_height":5,"out_width":4,"sampler":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run_add(read_only image2d_t img_in_0, read_only image2d_t img_in_1, write_only image2d_t img_out, sampler_t sampler, int out_width, int out_height) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float2 coord = (float2)((float)x / (float)out_width, (float)y / (float)out_height);
  if (x < out_width) {
    if (y < out_height) {
      float4 in_0 = read_imagef(img_in_0, sampler, coord);
      float4 in_1 = read_imagef(img_in_1, sampler, coord);
      write_imagef(img_out, (int2)(x, y), in_0 + in_1);
    }
  }
}