//{"a":0,"b":1,"c":2,"col":4,"com":8,"d":3,"w":7,"x":5,"y":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cut(global double* a, global double* b, global double* c, global double* d, unsigned long col, unsigned long x, unsigned long y, unsigned long w, unsigned char com) {
  unsigned long i = get_global_id(0);
  unsigned long j = get_global_id(1);
  a[hook(0, i * col + j)] = c[hook(2, (y + i) * w + x + j)];
  if (com) {
    b[hook(1, i * col + j)] = d[hook(3, (y + i) * w + x + j)];
  }
}