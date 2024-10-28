//{"BufferMat_i":3,"BufferMat_r":2,"Rmat_i":1,"Rmat_r":0,"firstCol":5,"firstRow":4,"nCols":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void full_rotations(global float* Rmat_r, global float* Rmat_i, global float* BufferMat_r, global float* BufferMat_i, int firstRow, int firstCol, int nCols) {
  int currentRotation = get_group_id(0);
  int lid = get_local_id(0);
  int locSize = get_local_size(0);

  local float rotCos_r;
  local float rotCos_i;
  local float rotSin_r;
  local float rotSin_i;

  float locR1_r;
  float locR1_i;
  float locR2_r;
  float locR2_i;

  local int skip;
  local int swap;
  local int skiprot;
  local int rotRow, rotCol, firstBlock, numBlocks;

  skip = 0;
  swap = 0;
  skiprot = 0;

  if (lid == 0) {
    rotRow = firstRow - currentRotation;
    rotCol = firstCol + currentRotation;
    firstBlock = rotCol / locSize;
    numBlocks = nCols / locSize - firstBlock;

    float a_r, a_i, b_r, b_i, sqab, modA, modB, tmpA, tmpB;
    a_r = Rmat_r[hook(0, rotCol * nCols + rotCol)];
    a_i = Rmat_i[hook(1, rotCol * nCols + rotCol)];
    b_r = BufferMat_r[hook(2, rotRow * nCols + rotCol)];
    b_i = BufferMat_i[hook(3, rotRow * nCols + rotCol)];

    tmpA = a_r * a_r + a_i * a_i;
    tmpB = b_r * b_r + b_i * b_i;
    sqab = sqrt(tmpA + tmpB);
    modA = sqrt(tmpA);
    modB = sqrt(tmpB);

    if (sqab < 0.00001f) {
      skip = 1;
    } else if (modB < 0.00001f) {
      rotCos_r = a_r / modA;
      rotCos_i = -a_i / modA;
      rotSin_r = 0.0f;
      rotSin_i = 0.0f;
      skiprot = 1;
    } else if (modA < 0.00001f) {
      rotCos_r = 0.0f;
      rotCos_i = 0.0f;

      rotSin_r = b_r / modB;
      rotSin_i = -b_i / modB;
      swap = 1;
    } else {
      rotCos_r = a_r / sqab;
      rotSin_r = b_r / sqab;
      rotCos_i = -a_i / sqab;
      rotSin_i = -b_i / sqab;
    }
  }

  barrier(0x01);

  if (skip) {
    return;
  }

  int curBlock;
  for (curBlock = 0; curBlock < numBlocks; curBlock++) {
    locR1_r = Rmat_r[hook(0, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)];
    locR1_i = Rmat_i[hook(1, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)];

    locR2_r = BufferMat_r[hook(2, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)];
    locR2_i = BufferMat_i[hook(3, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)];

    if (swap) {
      Rmat_r[hook(0, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)] = ((rotSin_r) * (locR2_r) - (rotSin_i) * (locR2_i));
      Rmat_i[hook(1, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)] = ((rotSin_r) * (locR2_i) + (rotSin_i) * (locR2_r));

      BufferMat_r[hook(2, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)] = ((-rotSin_r) * (locR1_r) - (rotSin_i) * (locR1_i));
      BufferMat_i[hook(3, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)] = ((-rotSin_r) * (locR1_i) + (rotSin_i) * (locR1_r));
    } else if (skiprot) {
      Rmat_r[hook(0, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)] = ((rotCos_r) * (locR1_r) - (rotCos_i) * (locR1_i));
      Rmat_i[hook(1, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)] = ((rotCos_r) * (locR1_i) + (rotCos_i) * (locR1_r));

      BufferMat_r[hook(2, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)] = ((rotCos_r) * (locR2_r) - (-rotCos_i) * (locR2_i));
      BufferMat_i[hook(3, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)] = ((rotCos_r) * (locR2_i) + (-rotCos_i) * (locR2_r));
    } else {
      Rmat_r[hook(0, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)] = ((rotCos_r) * (locR1_r) - (rotCos_i) * (locR1_i)) + ((rotSin_r) * (locR2_r) - (rotSin_i) * (locR2_i));
      Rmat_i[hook(1, rotCol * nCols + lid + (firstBlock + curBlock) * locSize)] = ((rotCos_r) * (locR1_i) + (rotCos_i) * (locR1_r)) + ((rotSin_r) * (locR2_i) + (rotSin_i) * (locR2_r));

      BufferMat_r[hook(2, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)] = ((rotCos_r) * (locR2_r) - (-rotCos_i) * (locR2_i)) + ((-rotSin_r) * (locR1_r) - (rotSin_i) * (locR1_i));
      BufferMat_i[hook(3, rotRow * nCols + lid + (firstBlock + curBlock) * locSize)] = ((rotCos_r) * (locR2_i) + (-rotCos_i) * (locR2_r)) + ((-rotSin_r) * (locR1_i) + (rotSin_i) * (locR1_r));
    }
  }

  barrier(0x02);
}