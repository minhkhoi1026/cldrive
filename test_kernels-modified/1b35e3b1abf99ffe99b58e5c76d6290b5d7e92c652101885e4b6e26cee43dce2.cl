//{"dst":2,"x":1,"y":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_atan2(global float* y, global float* x, global float* dst) {
  int i = get_global_id(0);
  dst[hook(2, i)] = atan2(y[hook(0, i)], x[hook(1, i)]);
}