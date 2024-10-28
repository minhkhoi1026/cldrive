//{"alpha":4,"beta":5,"matrixA":0,"matrixB":1,"matrixC":2,"matrixOrder":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sgemm(global float* restrict matrixA, global float* restrict const matrixB, global float* restrict matrixC, const unsigned int matrixOrder, const float alpha, const float beta) {
  const int i = get_global_id(1);
  const int j = get_global_id(0);
  float4 sum = (float4)0.0f;
  float4 matrixBColumn;

  matrixA += i * matrixOrder;

  unsigned int bOffset = j;

  for (int k = 0; k < matrixOrder; k += 4) {
    matrixBColumn.x = matrixB[hook(1, bOffset)];
    bOffset += matrixOrder;

    matrixBColumn.y = matrixB[hook(1, bOffset)];
    bOffset += matrixOrder;

    matrixBColumn.z = matrixB[hook(1, bOffset)];
    bOffset += matrixOrder;

    matrixBColumn.w = matrixB[hook(1, bOffset)];
    bOffset += matrixOrder;

    sum += vload4(0, matrixA) * matrixBColumn;
    matrixA += 4;
  }

  matrixC[hook(2, i * matrixOrder + j)] = alpha * (sum.x + sum.y + sum.z + sum.w) + beta * matrixC[hook(2, i * matrixOrder + j)];
}