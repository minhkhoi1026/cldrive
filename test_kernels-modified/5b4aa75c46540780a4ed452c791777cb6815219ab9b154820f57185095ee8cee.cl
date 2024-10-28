//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(global int* output) {
  int gid_x = get_global_id(0);

  for (int i = 0; i < 2147483647; ++i) {
    if (i == 1 && gid_x == 0) {
      output[hook(0, gid_x)] = i * 1000;
      break;
    }
    output[hook(0, gid_x)] = -1;
    if (i == 1 && gid_x == 1) {
      output[hook(0, gid_x)] = i * 2000;
      break;
    }

    output[hook(0, gid_x)] = -2;
    barrier(0x01);
    output[hook(0, gid_x)] = -3;
  }
}