//{"input":0,"matrix":3,"output":1,"vertical_offset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_csc_rgbatonv12(read_only image2d_t input, write_only image2d_t output, unsigned int vertical_offset, global float* matrix) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 0 | 0x10;
  float4 pixel_in1 = read_imagef(input, sampler, (int2)(2 * x, 2 * y));
  float4 pixel_in2 = read_imagef(input, sampler, (int2)(2 * x + 1, 2 * y));
  float4 pixel_in3 = read_imagef(input, sampler, (int2)(2 * x, 2 * y + 1));
  float4 pixel_in4 = read_imagef(input, sampler, (int2)(2 * x + 1, 2 * y + 1));
  float4 pixel_out_y1, pixel_out_y2, pixel_out_y3, pixel_out_y4, pixel_out_u, pixel_out_v;
  pixel_out_y1.x = matrix[hook(3, 0)] * pixel_in1.x + matrix[hook(3, 1)] * pixel_in1.y + matrix[hook(3, 2)] * pixel_in1.z;
  pixel_out_y1.y = 0.0;
  pixel_out_y1.z = 0.0;
  pixel_out_y1.w = 1.0;
  pixel_out_y2.x = matrix[hook(3, 0)] * pixel_in2.x + matrix[hook(3, 1)] * pixel_in2.y + matrix[hook(3, 2)] * pixel_in2.z;
  pixel_out_y2.y = 0.0;
  pixel_out_y2.z = 0.0;
  pixel_out_y2.w = 1.0;
  pixel_out_y3.x = matrix[hook(3, 0)] * pixel_in3.x + matrix[hook(3, 1)] * pixel_in3.y + matrix[hook(3, 2)] * pixel_in3.z;
  pixel_out_y3.y = 0.0;
  pixel_out_y3.z = 0.0;
  pixel_out_y3.w = 1.0;
  pixel_out_y4.x = matrix[hook(3, 0)] * pixel_in4.x + matrix[hook(3, 1)] * pixel_in4.y + matrix[hook(3, 2)] * pixel_in4.z;
  pixel_out_y4.y = 0.0;
  pixel_out_y4.z = 0.0;
  pixel_out_y4.w = 1.0;
  pixel_out_u.x = matrix[hook(3, 3)] * pixel_in1.x + matrix[hook(3, 4)] * pixel_in1.y + matrix[hook(3, 5)] * pixel_in1.z + 0.5;
  pixel_out_u.y = 0.0;
  pixel_out_u.z = 0.0;
  pixel_out_u.w = 1.0;
  pixel_out_v.x = matrix[hook(3, 6)] * pixel_in1.x + matrix[hook(3, 7)] * pixel_in1.y + matrix[hook(3, 8)] * pixel_in1.z + 0.5;
  pixel_out_v.y = 0.0;
  pixel_out_v.z = 0.0;
  pixel_out_v.w = 1.0;
  write_imagef(output, (int2)(2 * x, 2 * y), pixel_out_y1);
  write_imagef(output, (int2)(2 * x + 1, 2 * y), pixel_out_y2);
  write_imagef(output, (int2)(2 * x, 2 * y + 1), pixel_out_y3);
  write_imagef(output, (int2)(2 * x + 1, 2 * y + 1), pixel_out_y4);
  write_imagef(output, (int2)(2 * x, y + vertical_offset), pixel_out_u);
  write_imagef(output, (int2)(2 * x + 1, y + vertical_offset), pixel_out_v);
}