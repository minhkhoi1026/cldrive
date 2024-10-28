//{"dstImg":1,"height":4,"kernelWeights":5,"kernelWidth":6,"sampler":2,"srcImg":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gaussian_filter(read_only image2d_t srcImg, write_only image2d_t dstImg, sampler_t sampler, const int width, const int height, constant float* const kernelWeights, const int kernelWidth) {
  int2 outImageCoord = (int2)(get_global_id(0), get_global_id(1));
  int2 startImageCoord = (int2)(outImageCoord.x - (kernelWidth - 1) / 2, outImageCoord.y - (kernelWidth - 1) / 2);
  int2 endImageCoord = (int2)(outImageCoord.x + (kernelWidth - 1) / 2, outImageCoord.y + (kernelWidth + 1) / 2);

  if (outImageCoord.x < width && outImageCoord.y < height) {
    int weight = 0;
    float4 outColor = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
    for (int y = startImageCoord.y; y <= endImageCoord.y; y++) {
      for (int x = startImageCoord.x; x <= endImageCoord.x; x++) {
        outColor += (read_imagef(srcImg, sampler, (int2)(x, y)) * (kernelWeights[hook(5, weight)]));
        weight += 1;
      }
    }

    write_imagef(dstImg, outImageCoord, outColor);
  }
}