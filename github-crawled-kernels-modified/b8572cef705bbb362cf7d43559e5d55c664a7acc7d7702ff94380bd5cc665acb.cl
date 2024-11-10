//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_ctz_short(global short* src, global short* dst) {
  global short* A = &src[hook(0, get_global_id(0))];
  global short* B = &dst[hook(1, get_global_id(0))];
  *B = ctz(*A);
}