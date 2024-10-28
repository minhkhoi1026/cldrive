//{"dst":0,"hop":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct Test {
  char t0;
  int t1;
};

constant int two = 2;

kernel void compiler_local_slm1(global ulong* dst) {
  local int hop[16];
  dst[hook(0, 1)] = (ulong)&hop[hook(1, 1)];
  dst[hook(0, 0)] = (ulong)&hop[hook(1, 0)];
}