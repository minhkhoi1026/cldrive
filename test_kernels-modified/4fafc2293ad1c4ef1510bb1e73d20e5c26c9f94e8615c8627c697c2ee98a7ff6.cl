//{"A":0,"B":1,"C":2,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmult_square_float(global float* A, global float* B, global float* C, int size) {
  int l = get_global_id(0);

  int x = l / size;
  int y = l % size;

  float val = 0;
  for (int i = 0; i < size; i++) {
    val += A[hook(0, y + size * i)] * B[hook(1, i + size * x)];
  }

  C[hook(2, x * size + y)] = val;
}