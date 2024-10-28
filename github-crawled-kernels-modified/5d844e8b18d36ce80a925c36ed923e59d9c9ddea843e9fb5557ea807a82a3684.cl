//{"A":0,"C":1,"dimsA":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matmult3(global int* A, global int* C, private int2 dimsA) {
  unsigned int row = get_global_id(1);
  unsigned int col = get_global_id(0);

  if ((row < dimsA.y) && (col < dimsA.y)) {
    int sum = 0;
    for (unsigned int i = 0; i < dimsA.x; i++) {
      sum += A[hook(0, row * dimsA.x + i)] * A[hook(0, col * dimsA.x + i)];
    }
    C[hook(1, row * dimsA.y + col)] = sum;
  }
}