//{"dataCacheB":6,"matrixA":3,"matrixBTranspose":4,"matrixColsARowsB":1,"matrixColsB":2,"matrixProduct":5,"matrixRowsA":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMatrixMulOptimized(const int matrixRowsA, const int matrixColsARowsB, const int matrixColsB, const global float* matrixA, const global float* matrixBTranspose, global float* matrixProduct, local float* dataCacheB) {
  int gid = get_global_id(0);
  int lid = get_local_id(0);
  int lsize = get_local_size(0);
  int resultIndex = gid * matrixColsB;
  int iters = matrixColsARowsB >> 2;

  for (int j = 0; j < matrixColsB; j++) {
    int offset = j * matrixColsARowsB;
    for (int k = lid; (((k & 3) == 0) && k < matrixColsARowsB); k += lsize) {
      *((local float4*)&dataCacheB[hook(6, k)]) = *((global float4*)&matrixBTranspose[hook(4, k + offset)]);
    }

    barrier(0x01);

    int indexA = matrixColsARowsB * gid;
    int indexBTranspose = 0;
    float result = 0.0f;
    for (int i = 0; i < iters; i++) {
      float4 tmpRow = (*((global float4*)&matrixA[hook(3, indexA)]));
      float4 tmpCol = (*((local float4*)&dataCacheB[hook(6, indexBTranspose)]));
      result += dot(tmpRow, tmpCol);
      indexBTranspose += 4;
      indexA += 4;
    }
    matrixProduct[hook(5, resultIndex + j)] = result;

    barrier(0x01);
  }
}