//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testkernel(global int* data) {
  data[hook(0, get_global_id(0))] = 0x1;
}