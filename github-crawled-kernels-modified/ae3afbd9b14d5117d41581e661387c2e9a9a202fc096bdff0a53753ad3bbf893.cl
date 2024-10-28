//{"dst1":1,"dst2":2,"src":0,"tmp":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_mixed_pointer1(global unsigned int* src, global unsigned int* dst1, global unsigned int* dst2) {
  int x = get_global_id(0);
  global unsigned int* tmp = x < 5 ? dst1 : dst2;
  tmp[hook(3, x)] = src[hook(0, x)];
}