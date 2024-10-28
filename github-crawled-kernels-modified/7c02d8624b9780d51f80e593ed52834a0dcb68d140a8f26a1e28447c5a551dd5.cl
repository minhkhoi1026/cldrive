//{"A":3,"Q":6,"b":5,"m":1,"n":0,"x":4,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void largeMV(const int n, const int m, global float* y, global float* A, global float* x, global float* b) {
  local float Q[8 * 2];

  int t = get_local_id(0) / 2;
  int z = get_local_id(0) % 2;

  for (int i = t; i < n; i += 8) {
    Q[hook(6, t * 2 + z)] = 0.0f;
    for (int j = z; j < m; j += 2) {
      Q[hook(6, t * 2 + z)] += A[hook(3, j + i * m)] * x[hook(4, j)];
    }

    for (int stride = 2 / 2; stride > 0; stride >>= 1) {
      barrier(0x01);
      if (z + stride < 2) {
        Q[hook(6, t * 2 + z)] += Q[hook(6, t * 2 + z + stride)];
      }
    }

    if (z == 0) {
      y[hook(2, i)] = Q[hook(6, t * 2 + 0)] + b[hook(5, i)];
    }
  }
}