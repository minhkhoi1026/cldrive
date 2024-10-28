//{"a":0,"b":1,"c":2,"col":4,"com":6,"d":3,"offsetac":8,"offsetar":7,"row":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void trans(global double* a, global double* b, global double* c, global double* d, unsigned long col, unsigned long row, unsigned char com, unsigned long offsetar, unsigned long offsetac) {
  unsigned long i = get_global_id(0);
  unsigned long j = get_global_id(1);
  a[hook(0, j * row + i)] = c[hook(2, (i + offsetar) * col + j + offsetac)];
  if (com) {
    b[hook(1, j * row + i)] = d[hook(3, (i + offsetar) * col + j + offsetac)];
  }
}