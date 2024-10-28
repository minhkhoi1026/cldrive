//{"a":0,"b":1,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void subtraction_assignment(global double* a, global double* b, const int n) {
  int i = get_global_id(0);
  if (i > n)
    return;
  a[hook(0, i)] -= b[hook(1, i)];
}