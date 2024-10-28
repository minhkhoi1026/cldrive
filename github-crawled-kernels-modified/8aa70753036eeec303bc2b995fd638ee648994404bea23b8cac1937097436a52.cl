//{"in":0,"out":1,"source":3,"target":2}
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
      target[hook(2, offset)] = source[hook(3, posToOffset(blockStart + offsetAsPos, posToCol(sourceSize)))];
    }
  }
}
void copyLocal(local float* target, global float const* source, int N) {
  int numLoops = (N + get_local_size(0) - 1) / get_local_size(0);
  for (int loop = 0; loop < numLoops; loop++) {
    int offset = loop * get_local_size(0) + get_local_id(0);
    if (offset < N) {
      target[hook(2, offset)] = source[hook(3, offset)];
    }
  }
}

void copyGlobal(global float* target, local float const* source, int N) {
  int numLoops = (N + get_local_size(0) - 1) / get_local_size(0);
  for (int loop = 0; loop < numLoops; loop++) {
    int offset = loop * get_local_size(0) + get_local_id(0);
    if (offset < N) {
      target[hook(2, offset)] = source[hook(3, offset)];
    }
  }
}

kernel void testPos(global const float* in, global float* out) {
  if (get_global_id(0) == 0) {
    out[hook(1, 0)] = posToRow(in[hook(0, 0)]);
    out[hook(1, 1)] = posToCol(in[hook(0, 0)]);
    int pos = rowColToPos(in[hook(0, 1)], in[hook(0, 2)]);
    out[hook(1, 2)] = pos;
    out[hook(1, 3)] = posToRow(pos);
    out[hook(1, 4)] = posToCol(pos);
  }
}