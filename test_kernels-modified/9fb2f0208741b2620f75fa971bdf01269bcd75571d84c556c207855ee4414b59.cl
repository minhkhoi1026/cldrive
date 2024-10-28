//{"dataSize":1,"input":0,"output":3,"outputSize":4,"partsCount":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mergeData(global unsigned char* input, unsigned int dataSize, unsigned int partsCount, global unsigned char* output, unsigned int outputSize) {
  int wiId = get_global_id(0);
  int offset;
  int partSize = dataSize / partsCount;

  int tmp;
  int i, j;

  if (wiId == 0) {
    for (i = 0; i < partsCount; i++) {
      offset = i * partSize;
      tmp = (input[hook(0, offset + 3)] << 24) + (input[hook(0, offset + 2)] << 16) + (input[hook(0, offset + 1)] << 8) + input[hook(0, offset)];
      if (tmp > 0) {
        for (j = 0; j < partSize; j++) {
          output[hook(3, j)] = input[hook(0, offset + j)];
        }
        break;
      }
    }
  }
}