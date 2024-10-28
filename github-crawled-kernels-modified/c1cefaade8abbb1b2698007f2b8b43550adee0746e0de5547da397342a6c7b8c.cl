//{"dataSize":1,"input":0,"output":3,"outputSize":4,"partsCount":2,"result":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mergeData(global unsigned char* input, unsigned int dataSize, unsigned int partsCount, global unsigned char* output, unsigned int outputSize) {
  int wiId = get_global_id(0);
  int tmpId;
  int offset;
  int wiCount = get_global_size(0);
  int partSize = dataSize / partsCount;

  int itemsPerThread = partsCount / wiCount;
  int batch = itemsPerThread * wiCount;

  local int finder[1];
  local int result[2];

  int tmp;
  int i;

  if (itemsPerThread >= 1) {
    for (i = 0; i < itemsPerThread; i++) {
      tmpId = (wiId * itemsPerThread) + i;
      offset = tmpId * partSize;
      tmp = *((int*)input[hook(0, offset)]);
      if (tmp > 0) {
        *finder = wiId;
        result[hook(5, 0)] = offset;
        result[hook(5, 1)] = tmp;
      }
    }
  }
  if (partsCount - batch > 0) {
    tmpId = wiId + batch;
    offset = tmpId * partSize;
    if (tmpId <= partsCount - 1) {
      tmp = *((int*)input[hook(0, offset)]);
      if (tmp > 0) {
        *finder = wiId;
        result[hook(5, 0)] = offset;
        result[hook(5, 1)] = tmp;
      }
    }
  }
  barrier(0x01);

  if (wiId == *finder) {
    offset = result[hook(5, 0)];
    for (i = 0; i < result[hook(5, 1)]; i++) {
      output[hook(3, i)] = input[hook(0, offset + i)];
    }
  }
}