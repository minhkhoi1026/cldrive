//{"data":0,"l":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int* data, local int* l) {
  int x = data[hook(0, 0)];
  barrier(0x02);
  l[hook(1, 0)] = x;
}