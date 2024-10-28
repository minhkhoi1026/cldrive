//{"n":1,"scaleFactor":2,"values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Scale(global double* values, int n, const double scaleFactor) {
  for (int i = get_global_id(0); i < n; i += get_global_size(0)) {
    values[hook(0, i)] *= scaleFactor;
  }
}