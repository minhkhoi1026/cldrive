//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void assignLocalMany(global int* A, global int* B, global int* C) {
  int tid = get_global_id(0);
  int total = 0;
  for (int i = 0; i < 1024; i++)
    total += i;
  C[hook(2, tid)] = total;
}