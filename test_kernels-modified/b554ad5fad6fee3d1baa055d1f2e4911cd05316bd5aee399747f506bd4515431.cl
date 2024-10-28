//{"a":0,"b":1,"c":2,"com":4,"d":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rand(global double* a, global double* b, global long* c, global long* d, unsigned char com) {
  unsigned long i = get_global_id(0);
  a[hook(0, i)] = fabs((c[hook(2, i)] >> 11) * 0x1.0p-52);
  if (com) {
    b[hook(1, i)] = fabs((d[hook(3, i)] >> 11) * 0x1.0p-52);
  }
}