//{"BufferMat":1,"Rmat":0,"firstCol":3,"firstRow":2,"nCols":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void full_rotations(global float* Rmat, global float* BufferMat, int firstRow, int firstCol, int nCols) {
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
    firstBlock = rotCol / locSize;
    numBlocks = nCols / locSize - firstBlock;

    float a, b, sqab;
    a = Rmat[hook(0, rotCol * nCols + rotCol)];
    b = BufferMat[hook(1, rotRow * nCols + rotCol)];
    sqab = sqrt(a * a + b * b);
    if (sqab < 0.00001f) {
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
    locR1 = Rmat[hook(0, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)];
    locR2 = BufferMat[hook(1, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)];

    if (swap) {
      Rmat[hook(0, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)] = rotSin * locR2;

      BufferMat[hook(1, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)] = -rotSin * locR1;
    } else {
      Rmat[hook(0, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)] = rotCos * locR1 + rotSin * locR2;

      BufferMat[hook(1, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)] = rotCos * locR2 - rotSin * locR1;
    }
  }

  barrier(0x02);
}