//{"NNNSin":1,"RGBDin":0,"RGBDout":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clSSAO(read_only image2d_t RGBDin, read_only image2d_t NNNSin, write_only image2d_t RGBDout) {
  const sampler_t sampler = 0 | 0x20 | 4;

  const int gx = get_global_id(0);
  const int gy = get_global_id(1);
  const int gw = get_global_size(0);
  const int gh = get_global_size(1);

  float2 pixel = (float2)(gx + 0.5, gy + 0.5);

  float4 RGBD = read_imagef(RGBDin, sampler, pixel);
  float4 NNNS = read_imagef(NNNSin, sampler, pixel);

  float pixelDepth = RGBD.w;
  float result = 1.0;
  int count = 0;
  if (pixelDepth != 0) {
    for (int x = -2; x < 3; x++) {
      for (int y = -2; y < 3; y++) {
        if (NNNS.x * x + NNNS.y * y > 0) {
          float4 sample = read_imagef(RGBDin, sampler, pixel + (float2)(x, y));
          float sampleDepth = sample.w;

          float zd = clamp(fabs(pixelDepth - sampleDepth), 0.0f, pixelDepth * 0.007f) / (pixelDepth * 0.007f);
          result += 1.0f / (1.0f + zd * zd);
          count++;
        }
      }
    }
    result /= count;
  }

  RGBD.xyz *= result;
  RGBD.w = pixelDepth;

  write_imagef(RGBDout, (int2)(gx, gy), RGBD);
}