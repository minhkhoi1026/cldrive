//{"as":0,"bs":1,"n":2,"sortedChunksSize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(256, 1, 1))) kernel void merge(global const float* as, global float* bs, unsigned int n, unsigned int sortedChunksSize) {
  const unsigned int index = get_global_id(0);

  if (index >= n)
    return;

  unsigned int chunk1 = 2 * (index / (2 * sortedChunksSize));
  unsigned int chunk2 = chunk1 + 1;

  unsigned int chunkSize1 = (n > chunk1 * sortedChunksSize) ? min(sortedChunksSize, n - chunk1 * sortedChunksSize) : 0;
  unsigned int chunkSize2 = (n > chunk2 * sortedChunksSize) ? min(sortedChunksSize, n - chunk2 * sortedChunksSize) : 0;

  if (chunkSize2 == 0) {
    bs[hook(1, index)] = as[hook(0, index)];
    return;
  }

  unsigned int diagonalIndex = index - chunk1 * sortedChunksSize;
  unsigned int diagonalSize;
  if (diagonalIndex <= chunkSize1) {
    diagonalSize = diagonalIndex + 1;
  } else {
    diagonalSize = diagonalIndex + 1 - (diagonalIndex - chunkSize1);
  }

  int l = -1;
  int r = diagonalSize;

  while (l < r - 1) {
    int m = (l + r) / 2;
    unsigned int index1 = m - 1;
    unsigned int index2 = diagonalIndex - 1 - index1;
    float value1 = (index1 == -1) ? -0x1.fffffep127f : ((index1 >= chunkSize1) ? 0x1.fffffep127f : as[hook(0, chunk1 * sortedChunksSize + index1)]);
    float value2 = (index2 == -1) ? -0x1.fffffep127f : ((index2 >= chunkSize2) ? 0x1.fffffep127f : as[hook(0, chunk2 * sortedChunksSize + index2)]);
    if (value2 >= value1) {
      l = m;
    } else {
      r = m;
    }
  }

  unsigned int diagonalCrossingIndex = l;
  unsigned int index1 = diagonalCrossingIndex;
  unsigned int index2 = diagonalIndex - index1;
  float value1 = (index1 >= chunkSize1) ? 0x1.fffffep127f : as[hook(0, chunk1 * sortedChunksSize + index1)];
  float value2 = (index2 >= chunkSize2) ? 0x1.fffffep127f : as[hook(0, chunk2 * sortedChunksSize + index2)];

  bs[hook(1, index)] = min(value1, value2);
}