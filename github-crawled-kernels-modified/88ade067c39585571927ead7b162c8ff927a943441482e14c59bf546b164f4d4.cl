//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_half_improved(global ushort2* in, global ushort2* out) {
  unsigned int index = get_global_id(0);
  out[hook(1, index)] = in[hook(0, index)];
}