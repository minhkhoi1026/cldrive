//{"dst":0,"hop":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_volatile(global int* dst, local volatile int* hop) {
  hop[hook(1, get_global_id(0))] = get_local_id(1);
  dst[hook(0, get_global_id(0))] = hop[hook(1, get_local_id(0))];
}