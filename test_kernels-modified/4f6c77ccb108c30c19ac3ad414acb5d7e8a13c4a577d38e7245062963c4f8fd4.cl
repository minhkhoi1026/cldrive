//{"n":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void waste(global float* output, int n) {
  int i = get_global_id(0);
  int j;
  long rand;
  float x;
  if ((i >= 0) && (i < n)) {
    for (j = 0; j < 100; j++) {
      rand = i * j * __builtin_astype((i - j * i), float);
      rand *= rand << 32 ^ rand << 16 | rand;
      rand *= rand + __builtin_astype((rand), double);

      x = (float)rand;
    }

    output[hook(0, i)] = x;
  }
}