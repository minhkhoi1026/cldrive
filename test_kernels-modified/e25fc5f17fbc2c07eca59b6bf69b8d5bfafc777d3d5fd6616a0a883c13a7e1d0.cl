//{"a":0,"b":1,"by":2,"length":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int add_op(int a, int by) {
  return a + by;
}

kernel void add(global int* a, global int* b, int by, unsigned int length) {
  int i = get_global_id(0);
  if (i < length)
    b[hook(1, i)] = add_op(a[hook(0, i)], by);
}