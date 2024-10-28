//{"data":0,"im":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t s1 = 1 | 4 | 0x10;
const sampler_t s2 = 0 | 4 | 0x10;
const sampler_t s3 = 1 | 2 | 0x10;
const sampler_t s4 = 1 | 4 | 0x20;
kernel void foo(global float4* data, read_only image2d_t im) {
  data[hook(0, 0)] = read_imagef(im, s1, (float2)(0.0f, 0.0f));
  data[hook(0, 1)] = read_imagef(im, s2, (float2)(0.0f, 0.0f));
  data[hook(0, 2)] = read_imagef(im, s3, (float2)(0.0f, 0.0f));
  data[hook(0, 3)] = read_imagef(im, s4, (float2)(0.0f, 0.0f));
}