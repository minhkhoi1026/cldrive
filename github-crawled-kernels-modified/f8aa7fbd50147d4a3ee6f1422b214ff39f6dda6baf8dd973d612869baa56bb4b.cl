//{"dst":3,"src_0":0,"src_1":1,"src_2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mix_float16float16float16(global float16* src_0, global float16* src_1, global float16* src_2, global float16* dst) {
  int gid = get_global_id(0);
  dst[hook(3, gid)] = mix(src_0[hook(0, gid)], src_1[hook(1, gid)], src_2[hook(2, gid)]);
}