//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mul(global float* A, global float* B, global float* C) {
  const int columns = 4;
  const int rows = 4;

  int i = get_global_id(0);
  int j = get_global_id(1);

  if (i < columns && j < rows) {
    float tmp = 0.0;

    for (int k = 0; k < columns; ++k) {
      tmp += A[hook(0, i * rows + k)] * B[hook(1, i * rows + j)];
    }

    C[hook(2, i * rows + j)] = tmp;
  }
}