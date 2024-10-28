//{"dst":1,"signp":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_lgamma_r(global float* src, global float* dst, global int* signp) {
  int i = get_global_id(0);
  dst[hook(1, i)] = lgamma_r(src[hook(0, i)], signp + i);
}