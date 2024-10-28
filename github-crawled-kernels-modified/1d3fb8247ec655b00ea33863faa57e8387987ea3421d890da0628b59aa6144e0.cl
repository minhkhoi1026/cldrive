//{"A":0,"B":1,"C":2,"len":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_add(global const int* A, global const int* B, global int* C, const int len) {
  int tid = get_global_id(0);
  if (tid < len)
    C[hook(2, tid)] = A[hook(0, tid)] + B[hook(1, tid)];
}