//{"M":0,"cols":7,"flowx":2,"flowy":4,"mStep":1,"rows":6,"xStep":3,"yStep":5}
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

kernel void updateFlow(global const float* M, int mStep, global float* flowx, int xStep, global float* flowy, int yStep, const int rows, const int cols) {
  const int y = get_global_id(1);
  const int x = get_global_id(0);

  if (y < rows && y >= 0 && x < cols && x >= 0) {
    float g11 = M[hook(0, mad24(y, mStep, x))];
    float g12 = M[hook(0, mad24(rows + y, mStep, x))];
    float g22 = M[hook(0, mad24(2 * rows + y, mStep, x))];
    float h1 = M[hook(0, mad24(3 * rows + y, mStep, x))];
    float h2 = M[hook(0, mad24(4 * rows + y, mStep, x))];

    float detInv = 1.f / (g11 * g22 - g12 * g12 + 1e-3f);

    flowx[hook(2, mad24(y, xStep, x))] = (g11 * h2 - g12 * h1) * detInv;
    flowy[hook(4, mad24(y, yStep, x))] = (g22 * h1 - g12 * h2) * detInv;
  }
}