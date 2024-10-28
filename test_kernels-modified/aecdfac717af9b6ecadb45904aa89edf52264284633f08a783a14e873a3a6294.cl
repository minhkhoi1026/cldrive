//{"A":0,"B":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scan_add_atomic(global int* A, global int* B) {
  int id = get_global_id(0);
  int N = get_global_size(0);
  for (int i = id + 1; i < N && id < N; i++)
    atomic_add(&B[hook(1, i)], A[hook(0, id)]);
}