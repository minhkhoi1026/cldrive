//{"dst":1,"src_0":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void half_log10_float(global float* src_0, global float* dst) {
  int gid = get_global_id(0);
  dst[hook(1, gid)] = half_log10(src_0[hook(0, gid)]);
}