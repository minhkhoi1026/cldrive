//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int Argi(global int* buf, private int index) {
  if ((index == 0)) {
    return buf[hook(0, 1)];
  } else {
    return buf[hook(0, 2)];
  };
}
int f(global int* buf, private int y) {
  return Argi(buf, y);
}
kernel void brahmaKernel(global int* buf) {
  buf[hook(0, 0)] = f(buf, 0);
}