//{"dataSize":1,"input":0,"output":3,"outputSize":4,"partsCount":2,"subresults":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mergeData(global float* input, unsigned int dataSize, unsigned int partsCount, global float* output, unsigned int outputSize) {
  local float subresults[16];
  float localResult = 0.0;

  int id = get_global_id(0);
  int groupId = get_group_id(0);
  int localId = get_local_id(0);

  int actualItemsCount = dataSize / sizeof(float);
  int itemsPerThread = actualItemsCount / get_global_size(0);

  if (id == 0) {
    output[hook(3, 0)] = 0.0;
  }
  barrier(0x02);

  subresults[hook(5, localId)] = 0.0;
  barrier(0x01);

  for (int i = 0; i < itemsPerThread; i++) {
    int idx = (id * itemsPerThread) + i;
    subresults[hook(5, localId)] += input[hook(0, idx)];
  }
  barrier(0x01);

  for (int i = 0; i < 16; i++) {
    localResult += subresults[hook(5, i)];
  }

  if (localId == 0) {
    input[hook(0, groupId)] = localResult;
  }
  barrier(0x02);

  if (id == 0) {
    for (int i = 0; i < 8; i++) {
      output[hook(3, 0)] += input[hook(0, i)];
    }
  }
}