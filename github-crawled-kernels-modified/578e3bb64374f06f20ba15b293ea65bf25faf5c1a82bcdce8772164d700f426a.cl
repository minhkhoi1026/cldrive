//{"c0":0,"c1":1,"dst":2,"value":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_function_constant0(constant int* c0, constant char* c1, global int* dst, int value) {
  int id = (int)get_global_id(0);
  dst[hook(2, id)] = value + c0[hook(0, id % 69)] + c1[hook(1, 0)];
}