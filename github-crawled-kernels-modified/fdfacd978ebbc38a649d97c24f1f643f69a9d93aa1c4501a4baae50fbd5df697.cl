//{"A":0,"B":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_add_2(global const int* A, global int* B) {
  int id = get_global_id(0);
  int N = get_global_size(0);

  B[hook(1, id)] = A[hook(0, id)];

  barrier(0x02);

  for (int i = 1; i < N; i *= 2) {
    if (!(id % (i * 2)) && ((id + i) < N))
      B[hook(1, id)] += B[hook(1, id + i)];

    barrier(0x02);
  }
}