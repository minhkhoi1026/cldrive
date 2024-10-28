//{"A_data":0,"A_indices":1,"A_pointers":2,"B":3,"C":4,"alpha":8,"count":7,"m":5,"n":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void smvp(global double* A_data, global int* A_indices, global int* A_pointers, global double* B, global double* C, global int* m, global int* n, global int* count, global double* alpha) {
  int ROW = get_global_id(0);

  if (ROW < m[hook(5, 0)]) {
    int start = A_pointers[hook(2, ROW)];
    int end = (start == m[hook(5, 0)] - 1) ? (count[hook(7, 0)]) : A_pointers[hook(2, ROW + 1)];

    double sum = 0;
    for (int i = start; i < end; i++) {
      int index = A_indices[hook(1, i)];
      sum += (alpha[hook(8, 0)]) * A_data[hook(0, i)] * B[hook(3, index)];
    }
    C[hook(4, ROW)] = sum;
  }
}