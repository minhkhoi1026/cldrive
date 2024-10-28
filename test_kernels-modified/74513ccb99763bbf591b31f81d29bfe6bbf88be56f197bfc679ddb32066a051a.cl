//{"count":2,"input":0,"output":1,"webCLImage":3,"webCLSampler":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void getArg_sample(global float* input, global float* output, constant float* count, read_only image2d_t webCLImage, private sampler_t webCLSampler) {
  unsigned int i = get_global_id(0);
  output[hook(1, i)] = input[hook(0, i)];
}