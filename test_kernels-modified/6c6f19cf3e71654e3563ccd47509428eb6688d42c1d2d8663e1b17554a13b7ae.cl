//{"constant_a":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned int constant_a[2] = {0xabcd5432u, 0xaabb5533u};

kernel void test(global unsigned int* in, global unsigned int* out) {
  int i = get_global_id(0);
  int j = get_global_id(0) % (sizeof(constant_a) / sizeof(constant_a[hook(2, 0)]));

  out[hook(1, i)] = constant_a[hook(2, j)];
}