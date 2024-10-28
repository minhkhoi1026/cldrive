//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int* data) {
  int x = data[hook(0, 0)];
  mem_fence(0x02);
  data[hook(0, 1)] = x;
}