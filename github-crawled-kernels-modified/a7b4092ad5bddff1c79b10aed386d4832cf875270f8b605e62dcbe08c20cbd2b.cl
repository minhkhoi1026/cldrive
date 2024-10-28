//{"M":2,"flowx":0,"flowy":1,"height":3,"mStep":7,"width":4,"xStep":5,"yStep":6}
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

kernel void updateFlow(global float4* flowx, global float4* flowy, global const float4* M, const int height, const int width, int xStep, int yStep, int mStep) {
  const int y = get_global_id(1);
  const int x = get_global_id(0);

  xStep /= sizeof(*flowx);
  yStep /= sizeof(*flowy);
  mStep /= sizeof(*M);

  if (y < height && y >= 0 && x < width && x >= 0) {
    float4 g11 = M[hook(2, mad24(y, mStep, x))];
    float4 g12 = M[hook(2, mad24(height + y, mStep, x))];
    float4 g22 = M[hook(2, mad24(2 * height + y, mStep, x))];
    float4 h1 = M[hook(2, mad24(3 * height + y, mStep, x))];
    float4 h2 = M[hook(2, mad24(4 * height + y, mStep, x))];

    float4 detInv = (float4)(1.f) / (g11 * g22 - g12 * g12 + (float4)(1e-3f));

    flowx[hook(0, mad24(y, xStep, x))] = (g11 * h2 - g12 * h1) * detInv;
    flowy[hook(1, mad24(y, yStep, x))] = (g22 * h1 - g12 * h2) * detInv;
  }
}