//{"dst":1,"src_0":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void isnan_float(global float* src_0, global int* dst) {
  int gid = get_global_id(0);
  dst[hook(1, gid)] = (int)(isnan(src_0[hook(0, gid)]));
}