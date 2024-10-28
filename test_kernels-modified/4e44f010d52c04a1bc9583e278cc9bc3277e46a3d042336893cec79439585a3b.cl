//{"A":0,"B":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scan_hs(global int* A, global int* B) {
  int id = get_global_id(0);
  int N = get_global_size(0);
  global int* C;

  for (int stride = 1; stride < N; stride *= 2) {
    B[hook(1, id)] = A[hook(0, id)];
    if (id >= stride)
      B[hook(1, id)] += A[hook(0, id - stride)];

    barrier(0x02);

    C = A;
    A = B;
    B = C;
  }
}