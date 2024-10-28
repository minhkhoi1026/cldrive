//{"dataSize":1,"input":0,"output":2,"outputSize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void processData(global const float* input, unsigned int dataSize, global float* output, unsigned int outputSize) {
  int id = get_global_id(0);

  int actualItemsCount = outputSize / sizeof(float);
  int itemsPerThread = actualItemsCount / get_global_size(0);

  float delta = input[hook(0, 1)] - input[hook(0, 0)];

  for (int i = 0; i < itemsPerThread; i++) {
    int idx = (id * itemsPerThread) + i;
    output[hook(2, idx)] = exp(input[hook(0, idx)]) * delta;
  }
}