//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scalarMultiplication(const float a, global float* b) {
  int gid = get_global_id(0);
  for (int i = 0; i < 10000; i++) {
    for (int j = 0; j < 10000; j++) {
      b[hook(1, gid)] = a * b[hook(1, gid)];
      b[hook(1, gid)] = b[hook(1, gid)] / a;
    }
  }

  b[hook(1, gid)] = a * b[hook(1, gid)];
}