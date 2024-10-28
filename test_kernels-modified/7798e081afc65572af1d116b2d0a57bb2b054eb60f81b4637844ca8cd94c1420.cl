//{"A":0,"B":1,"numOfIterations":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefix_sum(global int* restrict A, global int* restrict B, private int numOfIterations) {
  size_t tid = get_global_id(0);

  for (int d = 0; d < numOfIterations; ++d) {
    if (tid >= (1 << d)) {
      B[hook(1, tid)] = A[hook(0, tid - (1 << d))] + A[hook(0, tid)];
    } else {
      B[hook(1, tid)] = A[hook(0, tid)];
    }
    barrier(0x02);

    global int* temp = A;
    A = B;
    B = temp;
  }
}