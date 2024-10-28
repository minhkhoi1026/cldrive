//{"argSampl":3,"coords":1,"input":0,"results":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t constSampl = 0x20;
kernel void sample_kernel(image2d_t input, float2 coords, global float4* results, sampler_t argSampl) {
  *results = read_imagef(input, constSampl, coords);
  *results = read_imagef(input, argSampl, coords);
  *results = read_imagef(input, 0x10 | 6, coords);
}