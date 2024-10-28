//{"base":1,"status":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_barrier(global int* status) {
  global int* base = status + get_global_id(0) * (8 + 4);
  base[hook(1, 0)] = 0;
  barrier(0x01);
  base[hook(1, 1)] = 1;
  barrier(0x02);
  base[hook(1, 2)] = 2;

  for (int i = 1; i < 8; i += 1) {
    barrier(0x01);
    base[hook(1, 3 + i)] = 3 + i;
  }
}