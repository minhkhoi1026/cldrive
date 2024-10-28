//{"data":0,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int bar(global int* x) {
  return x[hook(1, 0)];
}

kernel void foo(global int* data) {
  int x = bar(data);
  barrier(0x02);
  data[hook(0, 1)] = x;
}