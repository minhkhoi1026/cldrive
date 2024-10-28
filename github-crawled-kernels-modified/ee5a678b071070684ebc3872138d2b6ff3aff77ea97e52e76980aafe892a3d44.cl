//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_byte_improved(global uchar4* in, global uchar4* out) {
  unsigned int index = get_global_id(0);
  out[hook(1, index)] = in[hook(0, index)];
}