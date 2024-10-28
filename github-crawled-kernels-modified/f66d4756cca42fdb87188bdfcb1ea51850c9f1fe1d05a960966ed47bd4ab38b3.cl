//{"frameCount":2,"inputFrame0":3,"inputFrame1":4,"inputFrame2":5,"outputFrame":0,"thr":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_tnr_rgb(write_only image2d_t outputFrame, float thr, unsigned char frameCount, read_only image2d_t inputFrame0, read_only image2d_t inputFrame1, read_only image2d_t inputFrame2) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  sampler_t sampler = 0 | 0 | 0x10;
  float4 pixel_in0;
  float4 pixel_in1;
  float4 pixel_in2;

  pixel_in0 = read_imagef(inputFrame0, sampler, (int2)(x, y));
  pixel_in1 = read_imagef(inputFrame1, sampler, (int2)(x, y));
  pixel_in2 = read_imagef(inputFrame2, sampler, (int2)(x, y));

  float4 pixel_out;
  pixel_out.x = (pixel_in0.x + pixel_in1.x + pixel_in2.x) / 3.0f;
  pixel_out.y = (pixel_in0.y + pixel_in1.y + pixel_in2.y) / 3.0f;
  pixel_out.z = (pixel_in0.z + pixel_in1.z + pixel_in2.z) / 3.0f;
  pixel_out.w = (pixel_in0.w + pixel_in1.w + pixel_in2.w) / 3.0f;

  write_imagef(outputFrame, (int2)(x, y), pixel_out);
}