//{"buffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t hpSampler = 0 | 4 | 0x10;
kernel void initFloatBuffer(global float* buffer) {
  buffer[hook(0, get_global_id(0))] = 0.0f;
}