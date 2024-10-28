//{"input":0,"output":1,"outputStart":2,"outputStride":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(32, 8, 1))) kernel void imageToImageBuffer(read_only image2d_t input, global float* output, unsigned int outputStart, unsigned int outputStride) {
  sampler_t sampler = 0 | 0x20;

  const int2 g = (int2)(get_global_id(0), get_global_id(1));

  output[hook(1, outputStart + g.y * outputStride + g.x)] = read_imagef(input, sampler, g).s0;
}