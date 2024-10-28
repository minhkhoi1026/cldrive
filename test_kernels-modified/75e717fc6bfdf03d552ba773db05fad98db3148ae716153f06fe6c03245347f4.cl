//{"A":0,"B":1,"scratch":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_min(global const int* A, global int* B, local int* scratch) {
  int id = get_global_id(0);
  int lid = get_local_id(0);
  int N = get_local_size(0);

  scratch[hook(2, lid)] = A[hook(0, id)];

  barrier(0x01);

  for (int i = 1; i < N; i *= 2) {
    if (!(lid % (i * 2)) && ((lid + i) < N)) {
      if (scratch[hook(2, lid)] > scratch[hook(2, lid + i)])
        scratch[hook(2, lid)] = scratch[hook(2, lid + i)];
    }

    barrier(0x01);
  }

  if (!lid)
    atomic_min(&B[hook(1, 0)], scratch[hook(2, lid)]);
}