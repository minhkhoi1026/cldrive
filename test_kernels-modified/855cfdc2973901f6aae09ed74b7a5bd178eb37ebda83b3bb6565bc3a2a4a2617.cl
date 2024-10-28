//{"dest":1,"start":0,"val":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void set_valuesInt(int start, global int* dest, unsigned int val) {
  int pos = get_global_id(0) + start;
  dest[hook(1, pos)] = val;
}