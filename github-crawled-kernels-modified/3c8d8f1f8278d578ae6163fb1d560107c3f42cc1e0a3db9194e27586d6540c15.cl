//{"dataSize":1,"input":0,"output":3,"outputSize":4,"partsCount":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void partitionData(global const float* input, unsigned int dataSize, unsigned int partsCount, global float* output, unsigned int outputSize) {
  int id = get_global_id(0);

  int actualItemsCount = outputSize / sizeof(float);
  int itemsPerThread = actualItemsCount / get_global_size(0);

  float start = input[hook(0, 0)];
  float end = input[hook(0, 1)];

  float delta = (end - start) / actualItemsCount;
  for (int i = 0; i < itemsPerThread; i++) {
    int idx = (id * itemsPerThread) + i;
    output[hook(3, idx)] = start + (idx * delta);
  }
}