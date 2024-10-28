//{"dst":2,"src_0":0,"src_1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void subtract_uint8uint8(global uint8* src_0, global uint8* src_1, global uint8* dst) {
  int gid = get_global_id(0);
  dst[hook(2, gid)] = src_0[hook(0, gid)] - src_1[hook(1, gid)];
}