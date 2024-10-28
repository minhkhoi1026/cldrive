//{"alignment":2,"data":0,"newData":1,"sh":6,"wCardinal":4,"wCenter":3,"wDiagonal":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int ToGlobalRow(int gidRow, int lszRow, int lidRow) {
  return gidRow * lszRow + lidRow;
}

inline int ToGlobalCol(int gidCol, int lszCol, int lidCol) {
  return gidCol * lszCol + lidCol;
}

inline int ToFlatHaloedIdx(int row, int col, int rowPitch) {
  return (row + 1) * (rowPitch + 2) + (col + 1);
}

inline int ToFlatIdx(int row, int col, int pitch) {
  return row * pitch + col;
}

kernel void StencilKernel(global float* data, global float* newData, const int alignment, float wCenter, float wCardinal, float wDiagonal, local float* sh) {
  int gidRow = get_group_id(0);
  int gidCol = get_group_id(1);
  int gszRow = get_num_groups(0);
  int gszCol = get_num_groups(1);
  int lidRow = get_local_id(0);
  int lidCol = get_local_id(1);
  int lszRow = 16;
  int lszCol = get_local_size(1);

  int gRow = ToGlobalRow(gidRow, lszRow, lidRow);
  int gCol = ToGlobalCol(gidCol, lszCol, lidCol);

  int nCols = gszCol * lszCol + 2;
  int nPaddedCols = nCols + (((nCols % alignment) == 0) ? 0 : (alignment - (nCols % alignment)));
  int gRowWidth = nPaddedCols - 2;

  int lRowWidth = lszCol;
  for (int i = 0; i < (lszRow + 2); i++) {
    int lidx = ToFlatHaloedIdx(lidRow - 1 + i, lidCol, lRowWidth);
    int gidx = ToFlatHaloedIdx(gRow - 1 + i, gCol, gRowWidth);
    sh[hook(6, lidx)] = data[hook(0, gidx)];
  }

  if (lidCol == 0) {
    for (int i = 0; i < (lszRow + 2); i++) {
      int lidx = ToFlatHaloedIdx(lidRow - 1 + i, lidCol - 1, lRowWidth);
      int gidx = ToFlatHaloedIdx(gRow - 1 + i, gCol - 1, gRowWidth);
      sh[hook(6, lidx)] = data[hook(0, gidx)];
    }
  } else if (lidCol == (lszCol - 1)) {
    for (int i = 0; i < (lszRow + 2); i++) {
      int lidx = ToFlatHaloedIdx(lidRow - 1 + i, lidCol + 1, lRowWidth);
      int gidx = ToFlatHaloedIdx(gRow - 1 + i, gCol + 1, gRowWidth);
      sh[hook(6, lidx)] = data[hook(0, gidx)];
    }
  }

  barrier(0x01);

  for (int i = 0; i < lszRow; i++) {
    int cidx = ToFlatHaloedIdx(lidRow + i, lidCol, lRowWidth);
    int nidx = ToFlatHaloedIdx(lidRow - 1 + i, lidCol, lRowWidth);
    int sidx = ToFlatHaloedIdx(lidRow + 1 + i, lidCol, lRowWidth);
    int eidx = ToFlatHaloedIdx(lidRow + i, lidCol + 1, lRowWidth);
    int widx = ToFlatHaloedIdx(lidRow + i, lidCol - 1, lRowWidth);
    int neidx = ToFlatHaloedIdx(lidRow - 1 + i, lidCol + 1, lRowWidth);
    int seidx = ToFlatHaloedIdx(lidRow + 1 + i, lidCol + 1, lRowWidth);
    int nwidx = ToFlatHaloedIdx(lidRow - 1 + i, lidCol - 1, lRowWidth);
    int swidx = ToFlatHaloedIdx(lidRow + 1 + i, lidCol - 1, lRowWidth);

    float centerValue = sh[hook(6, cidx)];
    float cardinalValueSum = sh[hook(6, nidx)] + sh[hook(6, sidx)] + sh[hook(6, eidx)] + sh[hook(6, widx)];
    float diagonalValueSum = sh[hook(6, neidx)] + sh[hook(6, seidx)] + sh[hook(6, nwidx)] + sh[hook(6, swidx)];

    newData[hook(1, ToFlatHaloedIdx(gRow + i, gCol, gRowWidth))] = wCenter * centerValue + wCardinal * cardinalValueSum + wDiagonal * diagonalValueSum;
  }
}