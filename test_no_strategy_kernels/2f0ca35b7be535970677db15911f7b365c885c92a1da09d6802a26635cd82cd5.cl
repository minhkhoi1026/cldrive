//{"a":0,"res":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testConvertUToPtr(unsigned long a) {
  global unsigned int* res = (global unsigned int*)a;
  res[hook(1, 0)] = 0;
}