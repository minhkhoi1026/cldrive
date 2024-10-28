//{"d_out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reset_uchar_kernel(global uchar* d_out) {
  d_out[hook(0, get_global_id(0))] = 0;
}