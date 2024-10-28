//{"input":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(global uchar* input) {
  int i = get_global_id(0);
  global ushort* ushort_input = (global ushort*)(&input[hook(0, i)]);
  printf("%u,", *ushort_input);
}