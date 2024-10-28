//{"A":3,"B":4,"C":5,"K":2,"M":0,"N":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void myGEMM1(const int M, const int N, const int K, const global int* A, const global int* B, global int* C) {
  const int globalRow = get_global_id(0);
  const int globalCol = get_global_id(1);

  float acc = 0.0f;
  for (int k = 0; k < K; k++) {
    acc += A[hook(3, k * M + globalRow)] * B[hook(4, globalCol * K + k)];
  }

  C[hook(5, globalCol * M + globalRow)] = acc;
}