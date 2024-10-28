//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int z(private int a) {
  return (a + 1);
}
int f(global int* buf, private int y) {
  if ((y == 0)) {
    return z(9);
  } else {
    return buf[hook(0, 2)];
  };
}
kernel void brahmaKernel(global int* buf) {
  buf[hook(0, 0)] = f(buf, 0);
}