//{"cols":4,"dst":6,"lf":5,"lt":0,"lt_offset":2,"lt_step":1,"rows":3,"step_size":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AKAZE_nld_step_scalar(global const float* lt, int lt_step, int lt_offset, int rows, int cols, global const float* lf, global float* dst, float step_size) {
  int i = get_global_id(1);
  int j = get_global_id(0);

  if (!(i < rows && j < cols)) {
    return;
  }

  int a = (i - 1) * cols;
  int c = (i)*cols;
  int b = (i + 1) * cols;

  float res = 0.0f;
  if (i == 0) {
    if (j == 0 || j == (cols - 1)) {
      res = 0.0f;
    } else {
      res = (lf[hook(5, c + j)] + lf[hook(5, c + j + 1)]) * (lt[hook(0, c + j + 1)] - lt[hook(0, c + j)]) + (lf[hook(5, c + j)] + lf[hook(5, c + j - 1)]) * (lt[hook(0, c + j - 1)] - lt[hook(0, c + j)]) + (lf[hook(5, c + j)] + lf[hook(5, b + j)]) * (lt[hook(0, b + j)] - lt[hook(0, c + j)]);
    }
  } else if (i == (rows - 1)) {
    if (j == 0 || j == (cols - 1)) {
      res = 0.0f;
    } else {
      res = (lf[hook(5, c + j)] + lf[hook(5, c + j + 1)]) * (lt[hook(0, c + j + 1)] - lt[hook(0, c + j)]) + (lf[hook(5, c + j)] + lf[hook(5, c + j - 1)]) * (lt[hook(0, c + j - 1)] - lt[hook(0, c + j)]) + (lf[hook(5, c + j)] + lf[hook(5, a + j)]) * (lt[hook(0, a + j)] - lt[hook(0, c + j)]);
    }
  } else {
    if (j == 0) {
      res = (lf[hook(5, c + 0)] + lf[hook(5, c + 1)]) * (lt[hook(0, c + 1)] - lt[hook(0, c + 0)]) + (lf[hook(5, c + 0)] + lf[hook(5, b + 0)]) * (lt[hook(0, b + 0)] - lt[hook(0, c + 0)]) + (lf[hook(5, c + 0)] + lf[hook(5, a + 0)]) * (lt[hook(0, a + 0)] - lt[hook(0, c + 0)]);
    } else if (j == (cols - 1)) {
      res = (lf[hook(5, c + j)] + lf[hook(5, c + j - 1)]) * (lt[hook(0, c + j - 1)] - lt[hook(0, c + j)]) + (lf[hook(5, c + j)] + lf[hook(5, b + j)]) * (lt[hook(0, b + j)] - lt[hook(0, c + j)]) + (lf[hook(5, c + j)] + lf[hook(5, a + j)]) * (lt[hook(0, a + j)] - lt[hook(0, c + j)]);
    } else {
      res = (lf[hook(5, c + j)] + lf[hook(5, c + j + 1)]) * (lt[hook(0, c + j + 1)] - lt[hook(0, c + j)]) + (lf[hook(5, c + j)] + lf[hook(5, c + j - 1)]) * (lt[hook(0, c + j - 1)] - lt[hook(0, c + j)]) + (lf[hook(5, c + j)] + lf[hook(5, b + j)]) * (lt[hook(0, b + j)] - lt[hook(0, c + j)]) + (lf[hook(5, c + j)] + lf[hook(5, a + j)]) * (lt[hook(0, a + j)] - lt[hook(0, c + j)]);
    }
  }

  dst[hook(6, c + j)] = res * step_size;
}