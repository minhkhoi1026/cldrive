//{"A":0,"H":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hist_simple(global const int* A, global int* H) {
  int id = get_global_id(0);

  int bin_index = A[hook(0, id)];

  atomic_inc(&H[hook(1, bin_index)]);
}