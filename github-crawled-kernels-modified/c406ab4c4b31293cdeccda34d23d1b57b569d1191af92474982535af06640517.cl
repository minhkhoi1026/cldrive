//{"dst":3,"src_0":0,"src_1":1,"src_2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitselect_char2char2char2(global char2* src_0, global char2* src_1, global char2* src_2, global char2* dst) {
  int gid = get_global_id(0);
  dst[hook(3, gid)] = bitselect(src_0[hook(0, gid)], src_1[hook(1, gid)], src_2[hook(2, gid)]);
}