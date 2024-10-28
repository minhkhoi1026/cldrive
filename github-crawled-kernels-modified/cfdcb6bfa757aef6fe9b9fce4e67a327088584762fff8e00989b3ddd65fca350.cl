//{"matrixA":0,"matrixB":1,"matrixC":2,"widthA":3,"widthB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMultiplication(global double* matrixA, global double* matrixB, global double* matrixC, int widthA, int widthB) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  double sum = 0.0f;
  for (int k = 0; k < widthA; k++) {
    sum += matrixA[hook(0, j * widthA + k)] * matrixB[hook(1, i + k * widthB)];
  }
  matrixC[hook(2, j * widthB + i)] = sum;
}