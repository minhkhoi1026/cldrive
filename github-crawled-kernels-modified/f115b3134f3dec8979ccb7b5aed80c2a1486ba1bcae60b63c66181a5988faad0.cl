//{"argc":0,"b":2,"loop_b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(int argc, int loop_b) {
  int b[256];

  for (int i = 0; i < 256; i++)
    b[hook(2, i)] = argc;

  int index = 256;
  for (int i = 0; i < loop_b; i++) {
    index--;
    b[hook(2, index)] = 0;
  }

  printf("%i", b[hook(2, loop_b)]);
}