//{"dataSize":1,"digest":5,"fromTmp":6,"input":0,"output":3,"outputSize":4,"partsCount":2,"toTmp":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void partitionData(global unsigned char* input, unsigned int dataSize, unsigned int partsCount, global unsigned char* output, unsigned int outputSize) {
  int wiId = get_global_id(0);
  int offset;

  unsigned char digest[16];
  unsigned char fromTmp[sizeof(long)], toTmp[sizeof(long)];
  long from, to;
  long subRangeLen;
  int reminder;

  int i, j;
  long tmp;

  for (i = 0; i < 16; i++) {
    digest[hook(5, i)] = input[hook(0, i)];
  }
  for (i = 0; i < sizeof(long); i++) {
    fromTmp[hook(6, i)] = input[hook(0, i + 16)];
    toTmp[hook(7, i)] = input[hook(0, i + 16 + sizeof(long))];
  }
  from = *((long*)fromTmp);
  to = *((long*)toTmp);

  subRangeLen = (to - from) / partsCount;
  reminder = (to - from) % partsCount;

  if (wiId == 0) {
    for (i = 0; i < partsCount; i++) {
      offset = i * outputSize;
      for (j = 0; j < 16; j++) {
        output[hook(3, offset + j)] = digest[hook(5, j)];
      }
      tmp = from + (subRangeLen * i);
      *((long*)fromTmp) = tmp;
      tmp = from + (subRangeLen * (i + 1)) + reminder;
      if (tmp < 0L) {
        tmp = 9223372036854775807L;
      }
      *((long*)toTmp) = tmp;
      for (j = 0; j < sizeof(long); j++) {
        output[hook(3, j + offset + 16)] = fromTmp[hook(6, j)];
        output[hook(3, j + offset + 16 + sizeof(long))] = toTmp[hook(7, j)];
      }
    }
  }
}