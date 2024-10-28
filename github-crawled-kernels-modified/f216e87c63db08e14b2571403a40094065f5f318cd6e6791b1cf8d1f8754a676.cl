//{"matrixA":0,"matrixB":1,"matrixC":2,"widthA":3,"widthB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMultiplier(global float* matrixA, global float* matrixB, global float* matrixC, unsigned int widthA, unsigned int widthB) {
  const unsigned int rowC = get_global_id(0);
  const unsigned int colC = get_global_id(1);

  float result = 0.0f;
  for (unsigned int inner = 0; inner < widthA; ++inner)
    result += matrixA[hook(0, rowC * widthA + inner)] * matrixB[hook(1, inner * widthB + colC)];

  matrixC[hook(2, rowC * widthB + colC)] = result;
}