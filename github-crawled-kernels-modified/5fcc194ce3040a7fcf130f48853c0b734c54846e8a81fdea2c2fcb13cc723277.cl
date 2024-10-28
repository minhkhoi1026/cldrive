//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(global int* output) {
  int gid_x = get_global_id(0);

  for (volatile int i = 0; i < 2147483647; ++i) {
    if (i == 1 && gid_x == 0) {
      output[hook(0, gid_x)] = i * 1000;
      return;
    }
    output[hook(0, gid_x)] = -1;
    if (i == 1 && gid_x == 1) {
      output[hook(0, gid_x)] = i * 2000;
      return;
    }
    output[hook(0, gid_x)] = -2;
  }
  if (gid_x > 3) {
    output[hook(0, gid_x)] = 100;
  } else if (gid_x == 2) {
    output[hook(0, gid_x)] = 200;
  }
}