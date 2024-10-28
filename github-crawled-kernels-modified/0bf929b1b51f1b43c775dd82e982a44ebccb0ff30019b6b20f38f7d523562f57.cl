//{"a":0,"b":1,"col":2,"com":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void satlin(global double* a, global double* b, unsigned long col, unsigned char com) {
  unsigned long i = get_global_id(0) * col + get_global_id(1);

  if (a[hook(0, i)] < 0.0) {
    a[hook(0, i)] = 0.0;
  } else {
    a[hook(0, i)] = 1.0;
  }

  if (com) {
    b[hook(1, i)] = 0.0;
  }
}