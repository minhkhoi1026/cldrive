//{"input":0,"invScaleFactor":6,"output":1,"outputCentreX":4,"outputCentreY":5,"outputStart":2,"outputStride":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(32, 8, 1))) kernel void scaleImageToImageBuffer(read_only image2d_t input, global float* output, unsigned int outputStart, unsigned int outputStride, float outputCentreX, float outputCentreY, float invScaleFactor) {
  sampler_t sampler = 0 | 0x20;

  const int2 g = (int2)(get_global_id(0), get_global_id(1));

  const float2 inputCentre = convert_float2(get_image_dim(input) - 1) / 2.f;
  const float2 outputCentre = (float2)(outputCentreX, outputCentreY);

  const float2 inPos = invScaleFactor * (convert_float2(g) - outputCentre) + inputCentre;

  output[hook(1, outputStart + g.y * outputStride + g.x)] = read_imagef(input, sampler, inPos).s0;
}