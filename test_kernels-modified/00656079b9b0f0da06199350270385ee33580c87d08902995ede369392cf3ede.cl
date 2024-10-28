//{"A":0,"B":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void avg_filter(global const int* A, global int* B) {
  int id = get_global_id(0);
  B[hook(1, id)] = (A[hook(0, id - 1)] + A[hook(0, id)] + A[hook(0, id + 1)]) / 3;
}