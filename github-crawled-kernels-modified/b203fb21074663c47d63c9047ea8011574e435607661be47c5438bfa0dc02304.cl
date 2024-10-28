//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void runtime_use_host_ptr_buffer(global int* buf) {
  int id = (int)get_global_id(0);
  buf[hook(0, id)] = buf[hook(0, id)] / 2;
}