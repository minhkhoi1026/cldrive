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

kernel void compiler_local_slm(global int* dst) {
  local int hop[16];
  local char a;
  local struct Test c;

  c.t1 = get_group_id(0);
  a = two;
  hop[hook(1, get_local_id(0))] = get_local_id(0);
  barrier(0x01);
  dst[hook(0, get_global_id(0))] = hop[hook(1, get_local_id(0))] + (int)a + hop[hook(1, 1)] + c.t1;
}