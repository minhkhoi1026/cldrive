//{"dst":3,"src1":0,"src2":1,"src3":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_mad24(global int* src1, global int* src2, global int* src3, global int* dst) {
  int i = get_global_id(0);
  dst[hook(3, i)] = mad24(src1[hook(0, i)], src2[hook(1, i)], src3[hook(2, i)]);
}