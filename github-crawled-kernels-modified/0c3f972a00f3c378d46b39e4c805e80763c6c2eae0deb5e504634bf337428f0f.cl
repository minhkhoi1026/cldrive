//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void buffer(global uchar4* input, global uchar4* output) {
  size_t pixel = get_global_id(0) + get_global_id(1) * 16;
  uchar4 value = input[hook(0, pixel + get_global_id(2) * 16 * 128)];
  output[hook(1, pixel)] = value;
}