//{"dstBuffer":1,"height":3,"srcBuffer":0,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bilateralFilterKernel(global uchar4* srcBuffer, global uchar4* dstBuffer, const int width, const int height) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int centerIndex = y * width + x;
  float4 sum4 = (float4)0.0f;

  if ((x >= 2) && (x < (width - 2)) && (y >= 2) && (y < (height - 2))) {
    float4 centerPixel = 0.00392156862745f * convert_float4(srcBuffer[hook(0, centerIndex)]);
    float normalizeCoeff = 0.0f;

    for (int yy = -2; yy <= 2; yy++) {
      for (int xx = -2; xx <= 2; xx++) {
        int thisIndex = (y + yy) * width + (x + xx);
        float4 currentPixel = 0.00392156862745f * convert_float4(srcBuffer[hook(0, thisIndex)]);
        float domainDistance = fast_distance((float)(xx), (float)(yy));
        float domainWeight = exp(-0.5f * pow((domainDistance / 3.0f), 2.0f));

        float rangeDistance = fast_distance(currentPixel.xyz, centerPixel.xyz);
        float rangeWeight = exp(-0.5f * pow((rangeDistance / 0.2f), 2.0f));

        float totalWeight = domainWeight * rangeWeight;
        normalizeCoeff += totalWeight;
        sum4 += totalWeight * currentPixel;
      }
    }
    sum4 /= normalizeCoeff;
    sum4.w = 1.0f;
  }
  dstBuffer[hook(1, centerIndex)] = convert_uchar4_sat_rte(255.0f * sum4);
}