//{"K":5,"M":3,"N":4,"m1":6,"m2":7,"matrix1":0,"matrix2":1,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matmat_mult(global float* matrix1, global float* matrix2, global float* result, unsigned int M, unsigned int N, unsigned int K) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  unsigned int c, r;
  global float* m1 = matrix1;
  global float* m2 = matrix2;
  global float* res = result + i * K + j;

  for (c = 0; c < N; ++c) {
    *res += m1[hook(6, i * M + c)] * m2[hook(7, c * K + j)];
  }
}