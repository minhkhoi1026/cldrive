//{"dst":3,"src_0":0,"src_1":1,"src_2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clamp_floatfloatfloat(global float* src_0, global float* src_1, global float* src_2, global float* dst) {
  int gid = get_global_id(0);
  dst[hook(3, gid)] = clamp(src_0[hook(0, gid)], src_1[hook(1, gid)], src_2[hook(2, gid)]);
}