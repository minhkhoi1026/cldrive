//{"bar_return":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bar(global unsigned int* bar_return) {
  bar_return[hook(0, 0)] = 0xdeadbeef;
}