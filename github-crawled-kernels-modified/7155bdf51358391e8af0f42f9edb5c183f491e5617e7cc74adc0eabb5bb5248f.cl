//{"c_gKer":6,"cols":5,"dst":2,"dstStep":3,"ksizeHalf":7,"res":10,"row":9,"rows":4,"smem":8,"src":0,"srcStep":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int idx_row_low(const int y, const int last_row) {
  return abs(y) % (last_row + 1);
}

inline int idx_row_high(const int y, const int last_row) {
  return abs(last_row - abs(last_row - y)) % (last_row + 1);
}

inline int idx_col_low(const int x, const int last_col) {
  return abs(x) % (last_col + 1);
}

inline int idx_col_high(const int x, const int last_col) {
  return abs(last_col - abs(last_col - x)) % (last_col + 1);
}

inline int idx_col(const int x, const int last_col) {
  return idx_col_low(idx_col_high(x, last_col), last_col);
}

kernel void gaussianBlur5(global const float* src, int srcStep, global float* dst, int dstStep, const int rows, const int cols, global const float* c_gKer, const int ksizeHalf, local float* smem) {
  const int y = get_global_id(1);
  const int x = get_global_id(0);

  const int smw = (int)get_local_size(0) + 2 * ksizeHalf;
  local volatile float* row = smem + 5 * get_local_id(1) * smw;

  if (y < rows) {
    for (int i = (int)get_local_id(0); i < (int)get_local_size(0) + 2 * ksizeHalf; i += (int)get_local_size(0)) {
      int xExt = (int)(get_group_id(0) * (int)get_local_size(0)) + i - ksizeHalf;
      xExt = idx_col(xExt, cols - 1);

      for (int k = 0; k < 5; ++k)
        row[hook(9, k * smw + i)] = src[hook(0, mad24(k * rows + y, srcStep, xExt))] * c_gKer[hook(6, 0)];

      for (int j = 1; j <= ksizeHalf; ++j)
        for (int k = 0; k < 5; ++k)
          row[hook(9, k * smw + i)] += (src[hook(0, mad24(k * rows + idx_row_low(y - j, rows - 1), srcStep, xExt))] + src[hook(0, mad24(k * rows + idx_row_high(y + j, rows - 1), srcStep, xExt))]) * c_gKer[hook(6, j)];
    }
  }

  barrier(0x01);

  if (y < rows && y >= 0 && x < cols && x >= 0) {
    row += (int)get_local_id(0) + ksizeHalf;
    float res[5];

    for (int k = 0; k < 5; ++k)
      res[hook(10, k)] = row[hook(9, k * smw)] * c_gKer[hook(6, 0)];

    for (int i = 1; i <= ksizeHalf; ++i)
      for (int k = 0; k < 5; ++k)
        res[hook(10, k)] += (row[hook(9, k * smw - i)] + row[hook(9, k * smw + i)]) * c_gKer[hook(6, i)];

    for (int k = 0; k < 5; ++k)
      dst[hook(2, mad24(k * rows + y, dstStep, x))] = res[hook(10, k)];
  }
}