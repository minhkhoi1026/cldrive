//{"cols":5,"dst":2,"dstStep":3,"ksizeHalf":6,"res":9,"row":8,"rows":4,"smem":7,"src":0,"srcStep":1}
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

constant float c_border[5 + 1] = {0.14f, 0.14f, 0.4472f, 0.4472f, 0.4472f, 1.f};

kernel void boxFilter5(global const float* src, int srcStep, global float* dst, int dstStep, const int rows, const int cols, const int ksizeHalf, local float* smem) {
  const int y = get_global_id(1);
  const int x = get_global_id(0);

  const float boxAreaInv = 1.f / ((1 + 2 * ksizeHalf) * (1 + 2 * ksizeHalf));
  const int smw = (int)get_local_size(0) + 2 * ksizeHalf;
  local float* row = smem + 5 * get_local_id(1) * smw;

  if (y < rows) {
    for (int i = (int)get_local_id(0); i < (int)get_local_size(0) + 2 * ksizeHalf; i += (int)get_local_size(0)) {
      int xExt = (int)(get_group_id(0) * (int)get_local_size(0)) + i - ksizeHalf;
      xExt = min(max(xExt, 0), cols - 1);

      for (int k = 0; k < 5; ++k)
        row[hook(8, k * smw + i)] = src[hook(0, mad24(k * rows + y, srcStep, xExt))];

      for (int j = 1; j <= ksizeHalf; ++j)
        for (int k = 0; k < 5; ++k)
          row[hook(8, k * smw + i)] += src[hook(0, mad24(k * rows + max(y - j, 0), srcStep, xExt))] + src[hook(0, mad24(k * rows + min(y + j, rows - 1), srcStep, xExt))];
    }
  }

  barrier(0x01);

  if (y < rows && y >= 0 && x < cols && x >= 0) {
    row += (int)get_local_id(0) + ksizeHalf;
    float res[5];

    for (int k = 0; k < 5; ++k)
      res[hook(9, k)] = row[hook(8, k * smw)];

    for (int i = 1; i <= ksizeHalf; ++i)
      for (int k = 0; k < 5; ++k)
        res[hook(9, k)] += row[hook(8, k * smw - i)] + row[hook(8, k * smw + i)];

    for (int k = 0; k < 5; ++k)
      dst[hook(2, mad24(k * rows + y, dstStep, x))] = res[hook(9, k)] * boxAreaInv;
  }
}