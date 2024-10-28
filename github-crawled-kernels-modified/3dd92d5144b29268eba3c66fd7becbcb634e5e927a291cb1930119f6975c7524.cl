//{"A":2,"B":3,"C":4,"heightA":1,"widthB":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmmult(int widthB, int heightA, global int* A, global int* B, global int* C) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int tmp = 0;

  if ((i < heightA) && (j < widthB)) {
    tmp = 0;
    for (int k = 0; k < widthB; ++k) {
      tmp += A[hook(2, i * heightA + k)] * B[hook(3, k * widthB + j)];
    }
    C[hook(4, i * heightA + j)] = tmp;
  }
}