//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMult(constant float4* a, constant float4* b, global float* c) {
  int nRows = get_global_size(0);
  int vectorsPerRow = nRows / 4;
  int start = get_global_id(0) * vectorsPerRow;
  a += start;
  c += start * 4;

  float sum;

  for (int i = 0; i < nRows; ++i) {
    sum = 0.0f;
    for (int j = 0; j < vectorsPerRow; ++j)
      sum += dot(a[hook(0, j)], b[hook(1, i * vectorsPerRow + j)]);

    c[hook(2, i)] = sum;
  }
}