//{"colours":5,"dstImage":1,"kVals":3,"normalizationVal":4,"sampler":2,"srcImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve3x3(read_only image2d_t srcImage, write_only image2d_t dstImage, sampler_t sampler, constant float* kVals, float normalizationVal) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));

  float4 colour;
  float4 colours[9];

  colours[hook(5, 0)] = read_imagef(srcImage, sampler, coords + (int2)(-1, -1));
  colours[hook(5, 1)] = read_imagef(srcImage, sampler, coords + (int2)(0, -1));
  colours[hook(5, 2)] = read_imagef(srcImage, sampler, coords + (int2)(1, -1));
  colours[hook(5, 3)] = read_imagef(srcImage, sampler, coords + (int2)(-1, 0));
  colours[hook(5, 4)] = read_imagef(srcImage, sampler, coords + (int2)(0, 0));
  colours[hook(5, 5)] = read_imagef(srcImage, sampler, coords + (int2)(1, 0));
  colours[hook(5, 6)] = read_imagef(srcImage, sampler, coords + (int2)(-1, 1));
  colours[hook(5, 7)] = read_imagef(srcImage, sampler, coords + (int2)(0, 1));
  colours[hook(5, 8)] = read_imagef(srcImage, sampler, coords + (int2)(1, 1));

  colour = colours[hook(5, 0)] * kVals[hook(3, 0)] + colours[hook(5, 1)] * kVals[hook(3, 1)] + colours[hook(5, 2)] * kVals[hook(3, 2)];
  colour += colours[hook(5, 3)] * kVals[hook(3, 3)] + colours[hook(5, 4)] * kVals[hook(3, 4)] + colours[hook(5, 5)] * kVals[hook(3, 5)];
  colour += colours[hook(5, 6)] * kVals[hook(3, 6)] + colours[hook(5, 7)] * kVals[hook(3, 7)] + colours[hook(5, 8)] * kVals[hook(3, 8)];

  colour /= normalizationVal;
  write_imagef(dstImage, coords, colour);
}