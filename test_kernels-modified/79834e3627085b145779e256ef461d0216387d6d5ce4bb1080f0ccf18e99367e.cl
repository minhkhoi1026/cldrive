//{"buffer":0,"imgReadOnly":1,"imgWriteOnly":2,"sampler":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void objects(global unsigned int* buffer, read_only image2d_t imgReadOnly, write_only image2d_t imgWriteOnly, sampler_t sampler) {
  buffer[hook(0, 0)] = 0xdeadbeef;
}