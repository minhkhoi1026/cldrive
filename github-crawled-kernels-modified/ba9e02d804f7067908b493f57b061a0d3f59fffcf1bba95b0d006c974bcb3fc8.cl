//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void assignLocal(global int* A, global int* B, global int* C) {
  int tid = get_global_id(0);
  C[hook(2, tid)] = 1;
}