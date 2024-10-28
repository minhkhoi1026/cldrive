//{"c":2,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void bar(global int* x, int y) {
  *x = y;
}

kernel void foo(global int* x, global int* y, int c) {
  int z = x[hook(0, 0)];
  barrier(0x02);
  global int* ptr = c ? x : y;
  bar(ptr + 1, z);
}