//{"in":1,"inImage":2,"out":0,"read_imagef(inImage, 1 | 6 | 16, (float2){0.050000000000000003 * (float)i, 0.050000000000000003 * (float)i})":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 1 | 6 | 0x10;
kernel void foo(global float* out, global float* in, read_only image2d_t inImage) {
  unsigned int i = get_global_id(0);
  float sum = 0.0f;
  for (int j = 0; j < 4; ++j)
    sum += read_imagef(inImage, sampler, (float2)(0.05 * (float)i, 0.05 * (float)i))[hook(3, j)];
  out[hook(0, i)] = in[hook(1, i)] + 100.0f * sum;
}