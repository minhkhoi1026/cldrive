//{"A":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scan_bl(global int* A) {
  int id = get_global_id(0);
  int N = get_global_size(0);
  int t;

  for (int stride = 1; stride < N; stride *= 2) {
    if (((id + 1) % (stride * 2)) == 0)
      A[hook(0, id)] += A[hook(0, id - stride)];

    barrier(0x02);
  }

  if (id == 0)
    A[hook(0, N - 1)] = 0;

  barrier(0x02);

  for (int stride = N / 2; stride > 0; stride /= 2) {
    if (((id + 1) % (stride * 2)) == 0) {
      t = A[hook(0, id)];
      A[hook(0, id)] += A[hook(0, id - stride)];
      A[hook(0, id - stride)] = t;
    }

    barrier(0x02);
  }
}