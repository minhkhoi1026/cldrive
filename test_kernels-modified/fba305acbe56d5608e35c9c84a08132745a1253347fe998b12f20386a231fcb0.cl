//{"a":0,"res":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testConvertPtrToU(global int* a, global unsigned long* res) {
  res[hook(1, 0)] = (unsigned long)&a[hook(0, 0)];
}