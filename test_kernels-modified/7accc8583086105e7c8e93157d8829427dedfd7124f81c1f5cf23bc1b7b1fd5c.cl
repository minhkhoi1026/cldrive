//{"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int bar(global int* x) {
  return x[hook(0, 0)];
}

kernel void foo2(global int* x, global int* y) {
  int z = bar(x);
  barrier(0x02);
  y[hook(1, 0)] = z;
}