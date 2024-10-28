//{"count":6,"imageInput":1,"input":0,"outputFloat":3,"outputImage":4,"outputSampler":5,"samplerInput":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void basic(global float* input, image2d_t imageInput, sampler_t samplerInput, global float* outputFloat, global float* outputImage, global float* outputSampler, unsigned int count) {
  unsigned int i = get_global_id(0);
  if (i < count) {
    outputFloat[hook(3, i)] = input[hook(0, i)];
  }
}