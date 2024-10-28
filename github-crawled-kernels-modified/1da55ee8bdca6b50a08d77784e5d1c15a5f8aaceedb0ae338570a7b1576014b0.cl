//{"dataSize":1,"input":0,"output":2,"outputSize":3,"previewBuffer":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct PreviewObject {
  float f1;
  float f2;
  float f3;
};

kernel void processData(global float* input, unsigned int dataSize, global float* output, unsigned int outputSize, global struct PreviewObject* previewBuffer) {
  int id = get_global_id(0);

  int actualItemsCount = outputSize / sizeof(float);
  int itemsPerThread = actualItemsCount / get_global_size(0);

  float delta = input[hook(0, 1)] - input[hook(0, 0)];

  for (int i = 0; i < itemsPerThread; i++) {
    int idx = (id * itemsPerThread) + i;
    output[hook(2, idx)] = input[hook(0, idx)] * delta;
  }
}