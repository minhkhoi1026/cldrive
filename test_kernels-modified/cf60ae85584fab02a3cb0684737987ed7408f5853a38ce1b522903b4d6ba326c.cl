//{"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Test(global unsigned int* dst) {
  unsigned int index = get_global_id(0);
  dst[hook(0, index)] = index;
}