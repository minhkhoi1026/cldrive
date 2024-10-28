//{"dst":3,"src_0":0,"src_1":1,"src_2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mad_hi_uint4uint4uint4(global uint4* src_0, global uint4* src_1, global uint4* src_2, global uint4* dst) {
  int gid = get_global_id(0);
  dst[hook(3, gid)] = mad_hi(src_0[hook(0, gid)], src_1[hook(1, gid)], src_2[hook(2, gid)]);
}