//{"n":1,"val":2,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reset_x(global double* x, const int n, const double val) {
  int i = get_global_id(0);
  if (i < n) {
    x[hook(0, i)] = val;
  }
  return;
}