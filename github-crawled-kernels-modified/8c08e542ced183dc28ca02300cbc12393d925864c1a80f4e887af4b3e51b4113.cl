//{"dst":0,"dstStep":5,"height":3,"ksizeHalf":7,"res":9,"row":8,"smem":2,"src":1,"srcStep":6,"width":4}
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

inline int idx_row(const int y, const int last_row) {
  return idx_row_low(idx_row_high(y, last_row), last_row);
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

kernel void boxFilter5(global float* dst, global const float* src, local float* smem, const int height, const int width, int dstStep, int srcStep, const int ksizeHalf) {
  const int y = get_global_id(1);
  const int x = get_global_id(0);

  const float boxAreaInv = 1.f / ((1 + 2 * ksizeHalf) * (1 + 2 * ksizeHalf));
  const int smw = (int)get_local_size(0) + 2 * ksizeHalf;
  local float* row = smem + 5 * get_local_id(1) * smw;

  dstStep /= sizeof(*dst);
  srcStep /= sizeof(*src);

  if (y < height) {
    for (int i = (int)get_local_id(0); i < (int)get_local_size(0) + 2 * ksizeHalf; i += (int)get_local_size(0)) {
      int xExt = (int)(get_group_id(0) * (int)get_local_size(0)) + i - ksizeHalf;
      xExt = min(max(xExt, 0), width - 1);

      for (int k = 0; k < 5; ++k)
        row[hook(8, k * smw + i)] = src[hook(1, mad24(k * height + y, srcStep, xExt))];

      for (int j = 1; j <= ksizeHalf; ++j)
        for (int k = 0; k < 5; ++k)
          row[hook(8, k * smw + i)] += src[hook(1, mad24(k * height + max(y - j, 0), srcStep, xExt))] + src[hook(1, mad24(k * height + min(y + j, height - 1), srcStep, xExt))];
    }
  }

  barrier(0x01);

  if (y < height && y >= 0 && x < width && x >= 0) {
    row += (int)get_local_id(0) + ksizeHalf;
    float res[5];

    for (int k = 0; k < 5; ++k)
      res[hook(9, k)] = row[hook(8, k * smw)];

    for (int i = 1; i <= ksizeHalf; ++i)
      for (int k = 0; k < 5; ++k)
        res[hook(9, k)] += row[hook(8, k * smw - i)] + row[hook(8, k * smw + i)];

    for (int k = 0; k < 5; ++k)
      dst[hook(0, mad24(k * height + y, dstStep, x))] = res[hook(9, k)] * boxAreaInv;
  }
}