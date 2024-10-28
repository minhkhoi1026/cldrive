//{"A":2,"Q":5,"b":4,"n":0,"x":3,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduceMV(const int n, global float* y, global float* A, global float* x, global float* b) {
  int i = get_group_id(0);
  int j = get_local_id(0);

  local float Q[32];

  Q[hook(5, j)] = A[hook(2, i * 32 + j)] * x[hook(3, j)];

  for (int stride = 32 / 2; stride > 0; stride >>= 1) {
    barrier(0x01);
    if (j + stride < 32) {
      Q[hook(5, j)] += Q[hook(5, j + stride)];
    }
  }

  if (j == 0) {
    y[hook(1, i)] = Q[hook(5, 0)] + b[hook(4, i)];
  }
}