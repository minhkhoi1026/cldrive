//{"c0":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void write_linear(constant float* c0, global float* output) {
  unsigned int gid = get_global_id(0);
  output[hook(1, gid + 0 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 1 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 2 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 3 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 4 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 5 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 6 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 7 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 8 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 9 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 10 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 11 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 12 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 13 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 14 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 15 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 16 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 17 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 18 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 19 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 20 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 21 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 22 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 23 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 24 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 25 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 26 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 27 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 28 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 29 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 30 * (512 / sizeof(float)))] = *c0;
  output[hook(1, gid + 31 * (512 / sizeof(float)))] = *c0;
}