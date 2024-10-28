//{"image":0,"out":2,"sampler":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 bar(read_only image2d_t image, sampler_t sampler) {
  return read_imagef(image, sampler, (float2)(0.0));
}

kernel void foo(read_only image2d_t image, sampler_t sampler, global float4* out) {
  *out = bar(image, sampler);
}