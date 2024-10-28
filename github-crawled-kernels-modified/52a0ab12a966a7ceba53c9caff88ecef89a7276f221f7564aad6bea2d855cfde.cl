//{"c":0,"dst":1,"value":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_function_constant(constant short* c, global int* dst, int value) {
  int id = (int)get_global_id(0);
  dst[hook(1, id)] = value + c[hook(0, id % 69)];
}