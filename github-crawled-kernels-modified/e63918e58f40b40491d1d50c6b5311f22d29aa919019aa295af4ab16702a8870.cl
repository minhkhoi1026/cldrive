//{"n":1,"value":2,"values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Fill(global double* values, int n, const double value) {
  for (int i = get_global_id(0); i < n; i += get_global_size(0)) {
    values[hook(0, i)] = value;
  }
}