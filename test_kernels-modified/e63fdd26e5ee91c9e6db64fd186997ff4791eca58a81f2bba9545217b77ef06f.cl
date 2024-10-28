//{"im":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t s_nearest = 0x10 | 0 | 2;
const sampler_t s_linear = 0x20 | 0 | 2;
const sampler_t s_repeat = 0x10 | 0 | 6;
kernel void image_test(read_only image2d_t im, global float4* out) {
  out[hook(1, 0)] = read_imagef(im, s_nearest, (float2)(0.5f, 0.5f));
  out[hook(1, 1)] = read_imagef(im, s_nearest, (float2)(0.8f, 0.5f));
  out[hook(1, 2)] = read_imagef(im, s_nearest, (float2)(1.3f, 0.5f));

  out[hook(1, 3)] = read_imagef(im, s_linear, (float2)(0.5f, 0.5f));
  out[hook(1, 4)] = read_imagef(im, s_linear, (float2)(0.8f, 0.5f));
  out[hook(1, 5)] = read_imagef(im, s_linear, (float2)(1.3f, 0.5f));

  out[hook(1, 6)] = read_imagef(im, s_repeat, (float2)(4.5f, 0.5f));
  out[hook(1, 7)] = read_imagef(im, s_repeat, (float2)(5.0f, 0.5f));
  out[hook(1, 8)] = read_imagef(im, s_repeat, (float2)(6.5f, 0.5f));
}