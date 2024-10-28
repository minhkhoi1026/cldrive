//{"A":1,"B":2,"C":0,"dim":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sgemm(global float* C, const global float* A, const global float* B, const int dim) {
  const int globalRow = get_global_id(0);
  const int globalCol = get_global_id(1);

  float acc = 0.0;
  for (int k = 0; k < dim; k++) {
    float elementA = A[hook(1, globalRow * dim + k)];
    float elementB = B[hook(2, k * dim + globalCol)];
    acc += elementA * elementB;
  }

  C[hook(0, globalRow * dim + globalCol)] = acc;
}