//{"cols":3,"data":0,"gaus":5,"gaus[i]":4,"out":1,"rows":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float gaus[3][3] = {{0.0625, 0.125, 0.0625}, {0.1250, 0.250, 0.1250}, {0.0625, 0.125, 0.0625}};

kernel void convolution(global uchar* data, global uchar* out, unsigned int rows, unsigned int cols) {
  int sum = 0;
  size_t row = get_global_id(0);
  size_t col = get_global_id(1);
  size_t pos = row * cols + col;

  for (int i = 0; i < 3; i++)
    for (int j = 0; j < 3; j++) {
      sum += gaus[hook(5, i)][hook(4, j)] * data[hook(0, (i + row + -1) * cols + (j + col + -1))];
    }

  out[hook(1, pos)] = min(255, max(0, sum));
}