//{"dst1":0,"dst2":1,"dst3":2,"src":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_long_convert_2(global char* dst1, global short* dst2, global int* dst3, global long* src) {
  int i = get_global_id(0);
  dst1[hook(0, i)] = src[hook(3, i)];
  dst2[hook(1, i)] = src[hook(3, i)];
  dst3[hook(2, i)] = src[hook(3, i)];
}