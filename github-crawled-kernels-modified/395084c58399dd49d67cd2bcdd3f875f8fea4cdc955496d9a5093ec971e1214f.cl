//{"out0":0,"out1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_small_immediates(global int* out0, global float* out1) {
  out0[hook(0, 0)] = 3;
  out0[hook(0, 1)] = 7;
  out0[hook(0, 2)] = out1[hook(1, 0)] + 31.0f;
  out0[hook(0, 3)] = out0[hook(0, 3)] - 26;

  out1[hook(1, 0)] = out1[hook(1, 0)] + 7.0f;
}