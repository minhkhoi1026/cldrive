//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void integer_mad(global const unsigned int* a, global const unsigned int* b, global unsigned int* c) {
  int gid = get_global_id(0);

  unsigned int prod = a[hook(0, gid)] * 7 + b[hook(1, gid)];
  c[hook(2, gid)] = prod;
}