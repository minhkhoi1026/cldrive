//{"array0":1,"dst":0,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int x[16] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
kernel void compiler_private_const(global int* dst) {
  const int array0[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};

  dst[hook(0, get_global_id(0))] = array0[hook(1, get_global_id(0))] + x[hook(2, get_global_id(0))];
}