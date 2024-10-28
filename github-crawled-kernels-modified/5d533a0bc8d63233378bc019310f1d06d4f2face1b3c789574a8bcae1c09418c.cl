//{"dst":2,"src_0":0,"src_1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void isordered_float16float16(global float16* src_0, global float16* src_1, global int16* dst) {
  int gid = get_global_id(0);
  dst[hook(2, gid)] = (int16)(isordered(src_0[hook(0, gid)], src_1[hook(1, gid)]));
}