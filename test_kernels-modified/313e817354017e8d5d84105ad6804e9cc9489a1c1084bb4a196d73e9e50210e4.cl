//{"buffer":0,"sum":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t interpolationSampler = 0 | 2 | 0x20;
constant sampler_t hpSampler = 0 | 4 | 0x10;
kernel void initIntBufferID(global int* buffer, private int sum) {
  int id = get_global_id(0);
  if (id >= sum)
    id = 0;
  buffer[hook(0, id)] = id;
}