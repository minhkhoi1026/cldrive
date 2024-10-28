//{"dst":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_function_argument0(global int* dst, short value) {
  int id = (int)get_global_id(0);
  dst[hook(0, id)] = value;
}