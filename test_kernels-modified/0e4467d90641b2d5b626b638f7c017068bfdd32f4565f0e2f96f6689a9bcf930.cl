//{"a":0,"offset":1,"v":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addAt(global double* a, const int offset, const double v) {
  a[hook(0, offset)] += v;
}