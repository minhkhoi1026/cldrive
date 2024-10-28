//{"M":3,"N":4,"P":5,"m1":0,"m2":1,"mr":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMultiply(global const float* m1, global const float* m2, global float* mr, int M, int N, int P) {
  int mID = get_global_id(0);
  int nID = get_global_id(1);

  float sum = 0;

  int m1StartPoint = mID * N;
  for (int i = 0; i < N; i++) {
    sum += m1[hook(0, m1StartPoint + i)] * m2[hook(1, nID + i * P)];
  }
  mr[hook(2, mID * P + nID)] = sum;
}