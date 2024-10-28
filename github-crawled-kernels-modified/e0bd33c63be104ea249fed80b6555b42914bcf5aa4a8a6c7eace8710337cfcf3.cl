//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void store_keys_gpu(global unsigned char* in, global unsigned char* out) {
  unsigned int global_addr = get_global_id(0);
  in[hook(0, global_addr)] = out[hook(1, global_addr)];
}