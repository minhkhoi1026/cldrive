//{"matrixA":0,"matrixB":1,"matrixSize":3,"matrixWidth":4,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMultiplication_float(global float2* matrixA, global float* matrixB, global float* output, int matrixSize, int matrixWidth) {
  float2 sum;
  int y = get_global_id(0);
  int x = get_global_id(1);

  sum = (float2){0.0f, 0.0f};
  for (int i = 0; i < matrixWidth / 2; i++) {
    sum += matrixA[hook(0, x * matrixWidth / 2 + i)] * (float2){matrixB[hook(1, i * 2 * matrixSize + y)], matrixB[hook(1, (i * 2 + 1) * matrixSize + y)]};
  }
  output[hook(2, x * matrixSize + y)] = sum.x + sum.y;
}