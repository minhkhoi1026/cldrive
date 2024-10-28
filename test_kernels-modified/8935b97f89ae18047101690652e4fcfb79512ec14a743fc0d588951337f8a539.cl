//{"dst1":3,"dst2":4,"dst3":5,"src1":0,"src2":1,"src3":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_long_convert(global char* src1, global short* src2, global int* src3, global long* dst1, global long* dst2, global long* dst3) {
  int i = get_global_id(0);
  dst1[hook(3, i)] = src1[hook(0, i)];
  dst2[hook(4, i)] = src2[hook(1, i)];
  dst3[hook(5, i)] = src3[hook(2, i)];
}