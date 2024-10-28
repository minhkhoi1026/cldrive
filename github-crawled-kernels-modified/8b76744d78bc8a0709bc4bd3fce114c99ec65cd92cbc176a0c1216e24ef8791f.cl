//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scan(global int* input, global int* output) {
  unsigned int gid = get_global_id(0);
  int i;
  if (gid == 0) {
    output[hook(1, 0)] = input[hook(0, 0)];
    for (i = 1; i < 256; i++) {
      output[hook(1, i)] = output[hook(1, i - 1)] + input[hook(0, i)];
    }
  }
}