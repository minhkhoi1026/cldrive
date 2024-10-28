//{"result":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mad_test(global unsigned int* result) {
  unsigned int a = 0x123456;
  unsigned int b = 0x112233;
  unsigned int c = 0x111111;

  result[hook(0, 0)] = mad24(a, b, c);
  result[hook(0, 1)] = mad_hi(a, b, c);
}