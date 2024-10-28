//{"A":2,"m":1,"n":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gaussian(const int n, const int m, global float* A) {
  int id = get_local_id(0);

  for (int ma = 0; ma < m; ++ma) {
    float pp = A[hook(2, ma + ma * n)];
    float coeff = A[hook(2, ma + id * n)] / pp;
    barrier(0x02);
    if (id != ma) {
      for (int na = 0; na < n; ++na) {
        A[hook(2, na + id * n)] = A[hook(2, na + id * n)] - coeff * A[hook(2, na + n * ma)];
      }
    }
    barrier(0x02);
  }

  float coeff = A[hook(2, id + id * n)];
  for (int na = 0; na < n; ++na) {
    A[hook(2, na + id * n)] = A[hook(2, na + id * n)] / coeff;
  }
}