//{"A":0,"B":1,"C":2,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker(global int* A, global int* B, global int* C, int width) {
  int row_no = 128 * get_global_id(0) + get_global_id(1);

  int sum = 0;
  if (row_no < width) {
    for (int i = 0; i < width; i++) {
      sum = 0;
      for (int j = 0; j < width; j++) {
        sum = sum + (A[hook(0, width * row_no + j)] * B[hook(1, width * j + i)]);
      }
      C[hook(2, width * row_no + i)] = sum;
    }
  }
}