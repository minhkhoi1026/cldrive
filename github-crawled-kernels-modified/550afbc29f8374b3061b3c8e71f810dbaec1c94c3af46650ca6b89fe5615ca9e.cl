//{"dst":2,"src0":0,"src1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_div_short(global short* src0, global short* src1, global short* dst) {
  int id = (int)get_global_id(0);
  dst[hook(2, id)] = src0[hook(0, id)] / src1[hook(1, id)];
}