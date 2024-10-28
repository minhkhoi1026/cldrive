//{"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void LaunchOrderTest(global int* input, global int* output, int width) {
  int idx0 = get_global_id(0);
  int idx1 = get_global_id(1);

  atomic_inc(input);

  for (int i = 0; i < 100000; i++) {
    ;
  }

  output[hook(1, idx1 * width + idx0)] = input[hook(0, 0)];
}