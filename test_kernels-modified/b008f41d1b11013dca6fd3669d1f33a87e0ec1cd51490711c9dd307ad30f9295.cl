//{"dataSize":1,"input":0,"output":2,"outputSize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void processData(global const int* input, unsigned int dataSize, global int* output, unsigned int outputSize) {
  int i = get_global_id(0);

  output[hook(2, i)] = input[hook(0, i)];
}