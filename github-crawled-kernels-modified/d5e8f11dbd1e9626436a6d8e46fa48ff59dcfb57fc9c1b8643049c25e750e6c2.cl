//{"a":0,"offset":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void op_cos(global double* a, const int offset) {
  int i = get_global_id(0) + offset;
  a[hook(0, i)] = cos(a[hook(0, i)]);
}