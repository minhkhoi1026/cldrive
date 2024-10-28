//{"dst":1,"src_0":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void native_exp10_float16(global float16* src_0, global float16* dst) {
  int gid = get_global_id(0);
  dst[hook(1, gid)] = native_exp10(src_0[hook(0, gid)]);
}