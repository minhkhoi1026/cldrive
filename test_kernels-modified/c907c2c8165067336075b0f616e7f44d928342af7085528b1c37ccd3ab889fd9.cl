//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testLongRead(global const long* input, global long* output) {
  int i = get_global_id(0);

  output[hook(1, i)] = input[hook(0, i)] + 1;
}