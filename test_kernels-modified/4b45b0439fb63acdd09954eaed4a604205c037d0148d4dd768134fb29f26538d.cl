//{"blockPos":3,"blockSize":4,"destination":1,"localBuffer":5,"source":0,"sourceSize":2,"target":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int posToRow(int pos) {
  return (pos >> 10) & ((1 << 10) - 1);
}
int posToCol(int pos) {
  return pos & ((1 << 10) - 1);
}
int rowColToPos(int row, int col) {
  return (row << 10) | col;
}
int linearIdToPos(int linearId, int base) {
  return rowColToPos((linearId / base), (linearId % base));
}
int posToOffset(int pos, int rowLength) {
  return posToRow(pos) * rowLength + posToCol(pos);
}

void copyBlock(local float* target, global float const* source, const int sourceSize, const int blockStart, const int blockSize) {
  const int totalLinearSize = posToRow(blockSize) * posToCol(blockSize);
  const int numLoops = (totalLinearSize + get_local_size(0) - 1) / get_local_size(0);
  for (int loop = 0; loop < numLoops; loop++) {
    const int offset = get_local_id(0) + loop * get_local_size(0);
    if (offset < totalLinearSize) {
      const int offsetAsPos = linearIdToPos(offset, posToCol(blockSize));
      target[hook(6, offset)] = source[hook(0, posToOffset(blockStart + offsetAsPos, posToCol(sourceSize)))];
    }
  }
}
void copyLocal(local float* target, global float const* source, int N) {
  int numLoops = (N + get_local_size(0) - 1) / get_local_size(0);
  for (int loop = 0; loop < numLoops; loop++) {
    int offset = loop * get_local_size(0) + get_local_id(0);
    if (offset < N) {
      target[hook(6, offset)] = source[hook(0, offset)];
    }
  }
}

void copyGlobal(global float* target, local float const* source, int N) {
  int numLoops = (N + get_local_size(0) - 1) / get_local_size(0);
  for (int loop = 0; loop < numLoops; loop++) {
    int offset = loop * get_local_size(0) + get_local_id(0);
    if (offset < N) {
      target[hook(6, offset)] = source[hook(0, offset)];
    }
  }
}

kernel void run(global const float* source, global float* destination, int sourceSize, int blockPos, int blockSize, local float* localBuffer) {
  copyBlock(localBuffer, source, sourceSize, blockPos, blockSize);

  barrier(0x01);
  copyGlobal(destination, localBuffer, posToRow(blockSize) * posToCol(blockSize));
}