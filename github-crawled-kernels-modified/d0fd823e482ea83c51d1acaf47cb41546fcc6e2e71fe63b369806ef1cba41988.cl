//{"dst":0,"value":1,"value0":2,"value1":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_function_argument1(global int* dst, char value, short value0, int value1) {
  int id = (int)get_global_id(0);
  dst[hook(0, id)] = value + value0 + value1;
}