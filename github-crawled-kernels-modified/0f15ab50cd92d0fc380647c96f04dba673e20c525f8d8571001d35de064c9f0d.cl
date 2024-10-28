//{"dataSize":1,"input":0,"output":3,"outputSize":4,"partsCount":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void partitionData(global const int* input, unsigned int dataSize, unsigned int partsCount, global int* output, unsigned int outputSize) {
  int id = get_global_id(0);

  int itemsPerThread = outputSize / get_global_size(0);

  for (int i = 0; i < itemsPerThread; i++) {
    output[hook(3, (id * itemsPerThread) + i)] = input[hook(0, (id * itemsPerThread) + i)];
  }
}