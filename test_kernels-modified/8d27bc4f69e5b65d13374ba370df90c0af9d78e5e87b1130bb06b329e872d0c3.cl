//{"data":1,"dataSize":4,"res":2,"setSize":3,"trainingSet":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_compute(global const int* trainingSet, global const int* data, global int* res, int setSize, int dataSize) {
  int diff, toAdd, computeId;
  computeId = get_global_id(0);
  if (computeId < setSize) {
    diff = 0;
    for (int i = 0; i < dataSize; i++) {
      toAdd = data[hook(1, i)] - trainingSet[hook(0, computeId * dataSize + i)];
      diff += toAdd * toAdd;
    }
    res[hook(2, computeId)] = diff;
  }
}