//{"A":0,"B":1,"C":2,"height":4,"padding":5,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixAdd_same_shape(global float* A, global float* B, global float* C, unsigned long width, unsigned long height, int padding) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  unsigned long pos = y * (width + padding) + x;

  if (x < width && y < height)
    C[hook(2, pos)] = A[hook(0, pos)] + B[hook(1, pos)];
}