//{"dst":0,"n":2,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fill_buffer_int(global int* dst, int value, int n) {
  int gid = get_global_id(0);
  if (gid < n)
    dst[hook(0, gid)] = value;
}