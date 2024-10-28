//{"BufferMat":0,"colOffset":4,"firstCol":2,"firstRow":1,"nCols":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void partial_rotations(global float* BufferMat, int firstRow, int firstCol, int nCols, int colOffset) {
  int currentRotation = get_group_id(0);
  int lid = get_local_id(0);
  int locSize = get_local_size(0);

  local float rotCos;
  local float rotSin;

  float locR1;
  float locR2;
  local int skip;
  local int swap;
  local int rotRow, rotCol, firstBlock, numBlocks;

  skip = 0;
  swap = 0;

  if (lid == 0) {
    rotRow = firstRow - currentRotation;
    rotCol = firstCol + currentRotation;
    firstBlock = (rotCol + colOffset) / locSize;
    numBlocks = nCols / locSize - firstBlock;

    float a, b, sqab;
    a = BufferMat[hook(0, rotCol * nCols + rotCol + colOffset)];
    b = BufferMat[hook(0, rotRow * nCols + rotCol + colOffset)];
    sqab = sqrt(a * a + b * b);
    if (sqab < 0.00001f || fabs(b) < 0.00001f) {
      rotCos = 1.0f;
      rotSin = 0.0f;
      skip = 1;
    } else if (fabs(a) < 0.00001f) {
      rotCos = 0.0f;
      rotSin = b / sqab;
      swap = 1;
    } else {
      rotCos = a / sqab;
      rotSin = b / sqab;
    }
  }

  barrier(0x01);

  if (skip) {
    return;
  }

  int curBlock;
  for (curBlock = 0; curBlock < numBlocks; curBlock++) {
    locR1 = BufferMat[hook(0, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)];
    locR2 = BufferMat[hook(0, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)];

    if (swap) {
      BufferMat[hook(0, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)] = rotSin * locR2;

      BufferMat[hook(0, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)] = -rotSin * locR1;
    } else {
      BufferMat[hook(0, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)] = rotCos * locR1 + rotSin * locR2;

      BufferMat[hook(0, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)] = rotCos * locR2 - rotSin * locR1;
    }
  }

  barrier(0x02);
}