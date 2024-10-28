//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_ctz_int(global int* src, global int* dst) {
  global int* A = &src[hook(0, get_global_id(0))];
  global int* B = &dst[hook(1, get_global_id(0))];
  *B = ctz(*A);
}