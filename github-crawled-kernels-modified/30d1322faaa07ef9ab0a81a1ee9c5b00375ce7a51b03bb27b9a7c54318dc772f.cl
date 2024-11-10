//{"gain":4,"inputFrame":0,"inputFrame0":1,"outputFrame":2,"thr_uv":6,"thr_y":5,"vertical_offset":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_tnr_yuv(read_only image2d_t inputFrame, read_only image2d_t inputFrame0, write_only image2d_t outputFrame, unsigned int vertical_offset, float gain, float thr_y, float thr_uv) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  sampler_t sampler = 0 | 0 | 0x10;
  float4 pixel_t0_Y1 = read_imagef(inputFrame0, sampler, (int2)(2 * x, 2 * y));
  float4 pixel_t0_Y2 = read_imagef(inputFrame0, sampler, (int2)(2 * x + 1, 2 * y));
  float4 pixel_t0_Y3 = read_imagef(inputFrame0, sampler, (int2)(2 * x, 2 * y + 1));
  float4 pixel_t0_Y4 = read_imagef(inputFrame0, sampler, (int2)(2 * x + 1, 2 * y + 1));

  float4 pixel_t0_U = read_imagef(inputFrame0, sampler, (int2)(2 * x, y + vertical_offset));
  float4 pixel_t0_V = read_imagef(inputFrame0, sampler, (int2)(2 * x + 1, y + vertical_offset));

  float4 pixel_Y1 = read_imagef(inputFrame, sampler, (int2)(2 * x, 2 * y));
  float4 pixel_Y2 = read_imagef(inputFrame, sampler, (int2)(2 * x + 1, 2 * y));
  float4 pixel_Y3 = read_imagef(inputFrame, sampler, (int2)(2 * x, 2 * y + 1));
  float4 pixel_Y4 = read_imagef(inputFrame, sampler, (int2)(2 * x + 1, 2 * y + 1));

  float4 pixel_U = read_imagef(inputFrame, sampler, (int2)(2 * x, y + vertical_offset));
  float4 pixel_V = read_imagef(inputFrame, sampler, (int2)(2 * x + 1, y + vertical_offset));

  float diff_Y = 0.25 * (fabs(pixel_Y1.x - pixel_t0_Y1.x) + fabs(pixel_Y2.x - pixel_t0_Y2.x) + fabs(pixel_Y3.x - pixel_t0_Y3.x) + fabs(pixel_Y4.x - pixel_t0_Y4.x));

  float coeff_Y = 1.0;
  if (diff_Y < thr_y)
    coeff_Y = gain;

  float4 pixel_outY1;
  float4 pixel_outY2;
  float4 pixel_outY3;
  float4 pixel_outY4;
  pixel_outY1.x = pixel_t0_Y1.x + (pixel_Y1.x - pixel_t0_Y1.x) * coeff_Y;
  pixel_outY2.x = pixel_t0_Y2.x + (pixel_Y2.x - pixel_t0_Y2.x) * coeff_Y;
  pixel_outY3.x = pixel_t0_Y3.x + (pixel_Y3.x - pixel_t0_Y3.x) * coeff_Y;
  pixel_outY4.x = pixel_t0_Y4.x + (pixel_Y4.x - pixel_t0_Y4.x) * coeff_Y;

  float diff_U = fabs(pixel_U.x - pixel_t0_U.x);
  float diff_V = fabs(pixel_V.x - pixel_t0_V.x);

  float coeff_U = 1.0;
  if (diff_U < thr_uv)
    coeff_U = gain;

  float coeff_V = 1.0;
  if (diff_V < thr_uv)
    coeff_V = gain;

  float4 pixel_outU;
  float4 pixel_outV;
  pixel_outU.x = pixel_t0_U.x + (pixel_U.x - pixel_t0_U.x) * coeff_U;
  pixel_outV.x = pixel_t0_V.x + (pixel_V.x - pixel_t0_V.x) * coeff_V;

  write_imagef(outputFrame, (int2)(2 * x, 2 * y), pixel_outY1);
  write_imagef(outputFrame, (int2)(2 * x + 1, 2 * y), pixel_outY2);
  write_imagef(outputFrame, (int2)(2 * x, 2 * y + 1), pixel_outY3);
  write_imagef(outputFrame, (int2)(2 * x + 1, 2 * y + 1), pixel_outY4);
  write_imagef(outputFrame, (int2)(2 * x, y + vertical_offset), pixel_outU);
  write_imagef(outputFrame, (int2)(2 * x + 1, y + vertical_offset), pixel_outV);
}