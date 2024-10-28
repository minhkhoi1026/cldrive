//{"A":2,"B":5,"C":8,"height":1,"offA":4,"offB":7,"offC":10,"strideA":3,"strideB":6,"strideC":9,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void floatMatrixAdd(const unsigned int width, const unsigned int height, global float* A, const unsigned int strideA, const unsigned int offA, global float* B, const unsigned int strideB, const unsigned int offB, global float* C, const unsigned int strideC, const unsigned int offC) {
  int gx = get_global_id(0);
  int gy = get_global_id(1);

  if (gx < width && gy < height) {
    C[hook(8, offC + gy * strideC + gx)] = A[hook(2, offA + gy * strideA + gx)] + B[hook(5, offB + gy * strideB + gx)];
  }
}