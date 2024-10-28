//{"A":0,"B":1,"C":2,"K":5,"M":3,"N":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void myGEMM2(const global float* A, const global float* B, global float* C, unsigned int M, unsigned int N, unsigned int K) {
  const unsigned int globalRow = get_global_id(0);
  const unsigned int globalCol = get_global_id(1);

  float acc = 0.0f;
  for (unsigned int k = 0; k < K; k++) {
    acc += A[hook(0, k * M + globalRow)] * B[hook(1, globalCol * K + k)];
  }

  C[hook(2, globalCol * M + globalRow)] = acc;
}