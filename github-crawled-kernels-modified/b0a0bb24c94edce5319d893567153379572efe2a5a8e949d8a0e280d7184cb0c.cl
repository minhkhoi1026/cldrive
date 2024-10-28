//{"diff":2,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_abs_diff_ushort4(global ushort4* x, global ushort4* y, global ushort4* diff) {
  int i = get_global_id(0);
  diff[hook(2, i)] = abs_diff(x[hook(0, i)], y[hook(1, i)]);
}