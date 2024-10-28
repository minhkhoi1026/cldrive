//{"frameCount":5,"inputFrame0":6,"inputFrame1":7,"inputFrame2":8,"inputFrame3":9,"outputFrame":0,"thr_b":4,"thr_g":3,"thr_r":2,"tnr_gain":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_tnr_rgb(write_only image2d_t outputFrame, float tnr_gain, float thr_r, float thr_g, float thr_b, unsigned char frameCount, read_only image2d_t inputFrame0, read_only image2d_t inputFrame1, read_only image2d_t inputFrame2, read_only image2d_t inputFrame3) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  sampler_t sampler = 0 | 0 | 0x10;
  float4 pixel_in0;
  float4 pixel_in1;
  float4 pixel_in2;
  float4 pixel_in3;

  pixel_in0 = read_imagef(inputFrame0, sampler, (int2)(x, y));
  pixel_in1 = read_imagef(inputFrame1, sampler, (int2)(x, y));
  pixel_in2 = read_imagef(inputFrame2, sampler, (int2)(x, y));
  pixel_in3 = read_imagef(inputFrame3, sampler, (int2)(x, y));

  float4 pixel_out;
  float4 var;
  float gain = 0;
  var.x = (fabs(pixel_in0.x - pixel_in1.x) + fabs(pixel_in1.x - pixel_in2.x) + fabs(pixel_in2.x - pixel_in3.x)) / 3.0;
  var.y = (fabs(pixel_in0.y - pixel_in1.y) + fabs(pixel_in1.y - pixel_in2.y) + fabs(pixel_in2.y - pixel_in3.y)) / 3.0;
  var.z = (fabs(pixel_in0.z - pixel_in1.z) + fabs(pixel_in1.z - pixel_in2.z) + fabs(pixel_in2.z - pixel_in3.z)) / 3.0;
  if ((var.x + var.y + var.z) < (thr_r + thr_g + thr_b)) {
    gain = 1.0;
  }

  pixel_out.x = (gain * pixel_in0.x + gain * pixel_in1.x + gain * pixel_in2.x + pixel_in3.x) / (1.0f + 3 * gain);
  pixel_out.y = (gain * pixel_in0.y + gain * pixel_in1.y + gain * pixel_in2.y + pixel_in3.y) / (1.0f + 3 * gain);
  pixel_out.z = (gain * pixel_in0.z + gain * pixel_in1.z + gain * pixel_in2.z + pixel_in3.z) / (1.0f + 3 * gain);

  pixel_out.w = (pixel_in0.w + pixel_in1.w + pixel_in2.w + pixel_in3.w) / 4.0f;

  write_imagef(outputFrame, (int2)(x, y), pixel_out);
}