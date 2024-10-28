//{"buf":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void memset_int16(global int16_t* buf, int16_t value) {
  buf[hook(0, get_global_id(0))] = value;
}