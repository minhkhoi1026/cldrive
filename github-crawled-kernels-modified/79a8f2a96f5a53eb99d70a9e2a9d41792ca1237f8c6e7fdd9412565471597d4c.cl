//{"M":0,"R0":3,"R0Step":10,"R1":4,"R1Step":11,"c_border":12,"flowx":1,"flowy":2,"height":5,"mStep":7,"width":6,"xStep":8,"yStep":9}
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

kernel void updateMatrices(global float* M, global const float* flowx, global const float* flowy, global const float* R0, global const float* R1, const int height, const int width, int mStep, int xStep, int yStep, int R0Step, int R1Step) {
  const int y = get_global_id(1);
  const int x = get_global_id(0);

  mStep /= sizeof(*M);
  xStep /= sizeof(*flowx);
  yStep /= sizeof(*flowy);
  R0Step /= sizeof(*R0);
  R1Step /= sizeof(*R1);

  if (y < height && y >= 0 && x < width && x >= 0) {
    float dx = flowx[hook(1, mad24(y, xStep, x))];
    float dy = flowy[hook(2, mad24(y, yStep, x))];
    float fx = x + dx;
    float fy = y + dy;

    int x1 = convert_int(floor(fx));
    int y1 = convert_int(floor(fy));
    fx -= x1;
    fy -= y1;

    float r2, r3, r4, r5, r6;

    if (x1 >= 0 && y1 >= 0 && x1 < width - 1 && y1 < height - 1) {
      float a00 = (1.f - fx) * (1.f - fy);
      float a01 = fx * (1.f - fy);
      float a10 = (1.f - fx) * fy;
      float a11 = fx * fy;

      r2 = a00 * R1[hook(4, mad24(y1, R1Step, x1))] + a01 * R1[hook(4, mad24(y1, R1Step, x1 + 1))] + a10 * R1[hook(4, mad24(y1 + 1, R1Step, x1))] + a11 * R1[hook(4, mad24(y1 + 1, R1Step, x1 + 1))];

      r3 = a00 * R1[hook(4, mad24(height + y1, R1Step, x1))] + a01 * R1[hook(4, mad24(height + y1, R1Step, x1 + 1))] + a10 * R1[hook(4, mad24(height + y1 + 1, R1Step, x1))] + a11 * R1[hook(4, mad24(height + y1 + 1, R1Step, x1 + 1))];

      r4 = a00 * R1[hook(4, mad24(2 * height + y1, R1Step, x1))] + a01 * R1[hook(4, mad24(2 * height + y1, R1Step, x1 + 1))] + a10 * R1[hook(4, mad24(2 * height + y1 + 1, R1Step, x1))] + a11 * R1[hook(4, mad24(2 * height + y1 + 1, R1Step, x1 + 1))];

      r5 = a00 * R1[hook(4, mad24(3 * height + y1, R1Step, x1))] + a01 * R1[hook(4, mad24(3 * height + y1, R1Step, x1 + 1))] + a10 * R1[hook(4, mad24(3 * height + y1 + 1, R1Step, x1))] + a11 * R1[hook(4, mad24(3 * height + y1 + 1, R1Step, x1 + 1))];

      r6 = a00 * R1[hook(4, mad24(4 * height + y1, R1Step, x1))] + a01 * R1[hook(4, mad24(4 * height + y1, R1Step, x1 + 1))] + a10 * R1[hook(4, mad24(4 * height + y1 + 1, R1Step, x1))] + a11 * R1[hook(4, mad24(4 * height + y1 + 1, R1Step, x1 + 1))];

      r4 = (R0[hook(3, mad24(2 * height + y, R0Step, x))] + r4) * 0.5f;
      r5 = (R0[hook(3, mad24(3 * height + y, R0Step, x))] + r5) * 0.5f;
      r6 = (R0[hook(3, mad24(4 * height + y, R0Step, x))] + r6) * 0.25f;
    } else {
      r2 = r3 = 0.f;
      r4 = R0[hook(3, mad24(2 * height + y, R0Step, x))];
      r5 = R0[hook(3, mad24(3 * height + y, R0Step, x))];
      r6 = R0[hook(3, mad24(4 * height + y, R0Step, x))] * 0.5f;
    }

    r2 = (R0[hook(3, mad24(y, R0Step, x))] - r2) * 0.5f;
    r3 = (R0[hook(3, mad24(height + y, R0Step, x))] - r3) * 0.5f;

    r2 += r4 * dy + r6 * dx;
    r3 += r6 * dy + r5 * dx;

    float scale = c_border[hook(12, min(x, 5))] * c_border[hook(12, min(y, 5))] * c_border[hook(12, min(width - x - 1, 5))] * c_border[hook(12, min(height - y - 1, 5))];

    r2 *= scale;
    r3 *= scale;
    r4 *= scale;
    r5 *= scale;
    r6 *= scale;

    M[hook(0, mad24(y, mStep, x))] = r4 * r4 + r6 * r6;
    M[hook(0, mad24(height + y, mStep, x))] = (r4 + r5) * r6;
    M[hook(0, mad24(2 * height + y, mStep, x))] = r5 * r5 + r6 * r6;
    M[hook(0, mad24(3 * height + y, mStep, x))] = r4 * r2 + r6 * r3;
    M[hook(0, mad24(4 * height + y, mStep, x))] = r6 * r2 + r5 * r3;
  }
}