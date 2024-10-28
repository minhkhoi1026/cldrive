//{"image":0,"sampler":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t global_sampler = 1;
void foo(image2d_t image, sampler_t sampler) {
  read_imagef(image, sampler, (float2)(0, 0));
}

void foo_const(image2d_t image, sampler_t sampler) {
  const sampler_t sampler1 = 1;

  const sampler_t sampler2 = sampler;
  read_imagef(image, sampler1, (float2)(0, 0));
}

kernel void unsafe_builtins(image2d_t image, sampler_t sampler) {
  foo(image, sampler);

  foo(image, global_sampler);
}