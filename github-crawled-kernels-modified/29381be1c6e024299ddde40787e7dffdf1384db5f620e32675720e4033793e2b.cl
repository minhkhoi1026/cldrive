//{"A":0,"B":1,"C":2,"dimsA":3,"dimsB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matmult0(global int* A, global int* B, global int* C, private int2 dimsA, private int2 dimsB) {
  unsigned int col = get_global_id(0);
  unsigned int row = get_global_id(1);

  if ((row < dimsA.y) && (col < dimsB.x)) {
    int sum = 0;
    for (unsigned int i = 0; i < dimsA.x; i++) {
      sum += A[hook(0, row * dimsA.x + i)] * B[hook(1, i * dimsB.x + col)];
    }
    C[hook(2, row * dimsB.x + col)] = sum;
  }
}