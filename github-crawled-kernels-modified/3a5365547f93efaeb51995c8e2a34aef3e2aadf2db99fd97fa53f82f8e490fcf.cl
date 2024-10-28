//{"dst":1,"src_0":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pre_increment_uchar2(global uchar2* src_0, global uchar2* dst) {
  int gid = get_global_id(0);
  dst[hook(1, gid)] = ++src_0[hook(0, gid)];
}