//{"A":6,"A_internal_size1":1,"A_size1":0,"B":7,"B_internal_size2":4,"B_size1":2,"B_size2":3,"C":8,"C_internal_size2":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void iMatMult(const int A_size1, const int A_internal_size1, const int B_size1, const int B_size2, const int B_internal_size2, const int C_internal_size2, global const int* A, global const int* B, global int* C) {
  const int globalRow = get_global_id(0);
  const int globalCol = get_global_id(1);
  int tmp = 0;

  if ((globalRow < A_size1) && (globalCol < B_size2)) {
    for (int k = 0; k < B_size1; k++) {
      tmp += A[hook(6, globalRow * A_internal_size1 + k)] * B[hook(7, globalCol + B_internal_size2 * k)];
    }

    C[hook(8, globalCol + C_internal_size2 * globalRow)] = tmp;
  }
}