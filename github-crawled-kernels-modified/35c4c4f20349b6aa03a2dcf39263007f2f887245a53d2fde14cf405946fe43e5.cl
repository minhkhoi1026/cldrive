//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vectSquareUChar(global uchar* input, global uchar* output) {
  size_t id = get_global_id(0);
  output[hook(1, id)] = input[hook(0, id)] * input[hook(0, id)];
}