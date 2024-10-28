//{"a":0,"b":1,"by":2,"length":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void increment(global int* a, global int* b, int by, unsigned int length) {
  int i = get_global_id(0);
  if (i < length)
    b[hook(1, i)] = a[hook(0, i)] + by;
}