//{"c_gKer":6,"cols":5,"dst":2,"dstStep":3,"ksizeHalf":7,"row":9,"rows":4,"smem":8,"src":0,"srcStep":1}
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

kernel void gaussianBlur(global const float* src, int srcStep, global float* dst, int dstStep, const int rows, const int cols, global const float* c_gKer, const int ksizeHalf, local float* smem) {
  const int y = get_global_id(1);
  const int x = get_global_id(0);

  local float* row = smem + get_local_id(1) * ((int)get_local_size(0) + 2 * ksizeHalf);

  if (y < rows) {
    for (int i = (int)get_local_id(0); i < (int)get_local_size(0) + 2 * ksizeHalf; i += (int)get_local_size(0)) {
      int xExt = (int)(get_group_id(0) * (int)get_local_size(0)) + i - ksizeHalf;
      xExt = idx_col(xExt, cols - 1);
      row[hook(9, i)] = src[hook(0, mad24(y, srcStep, xExt))] * c_gKer[hook(6, 0)];
      for (int j = 1; j <= ksizeHalf; ++j)
        row[hook(9, i)] += (src[hook(0, mad24(idx_row_low(y - j, rows - 1), srcStep, xExt))] + src[hook(0, mad24(idx_row_high(y + j, rows - 1), srcStep, xExt))]) * c_gKer[hook(6, j)];
    }
  }

  barrier(0x01);

  if (y < rows && y >= 0 && x < cols && x >= 0) {
    row += (int)get_local_id(0) + ksizeHalf;
    float res = row[hook(9, 0)] * c_gKer[hook(6, 0)];
    for (int i = 1; i <= ksizeHalf; ++i)
      res += (row[hook(9, -i)] + row[hook(9, i)]) * c_gKer[hook(6, i)];

    dst[hook(2, mad24(y, dstStep, x))] = res;
  }
}