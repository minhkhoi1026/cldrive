//{"dst":2,"src1":0,"src2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_upsample_long(global int* src1, global unsigned int* src2, global long* dst) {
  int i = get_global_id(0);
  dst[hook(2, i)] = upsample(src1[hook(0, i)], src2[hook(1, i)]);
}