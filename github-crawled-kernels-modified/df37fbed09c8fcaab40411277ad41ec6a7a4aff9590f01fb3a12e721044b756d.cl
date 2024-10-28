//{"cols":4,"left":0,"result":2,"right":1,"rows":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MMMultiply(global double* left, global double* right, global double* result, int rows, int cols) {
  for (int i = get_global_id(0); i < rows; i += get_global_size(0)) {
    for (int j = get_global_id(1); j < cols; j += get_global_size(1)) {
      int offsetI = i * cols;
      double tmp = 0;
      for (int k = 0; k < cols; k++) {
        tmp += left[hook(0, offsetI + k)] * right[hook(1, k * cols + j)];
      }

      result[hook(2, i * cols + j)] = tmp;
    }
  }
}