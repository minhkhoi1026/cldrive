//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void setupLowProcTest(global unsigned int* input, global unsigned int* output) {
  unsigned int tid = get_global_id(0);
  output[hook(1, 0)] = input[hook(0, 0)] * 2;
}