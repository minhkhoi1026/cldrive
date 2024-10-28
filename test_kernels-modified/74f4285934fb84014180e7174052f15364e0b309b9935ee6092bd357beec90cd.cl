//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_remove_constant_load_in_loops_opt(global float a[], global float b[]) {
  for (int j = 0; j < 200; j++) {
    for (int i = 0; i < 200; i++) {
      a[hook(0, i + j * 200)] = i * j;
    }
  }

  for (int i = 0; i < 40000; i++) {
    b[hook(1, i)] = i;
  }
}