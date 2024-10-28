//{"cols":2,"pdims":0,"rows":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void map_rows_to_cols(global const int* pdims, global const long* rows, global long* cols) {
  int i = get_global_id(0);
  const int dims = *pdims;
  for (int j = 0; j < dims; ++j) {
    cols[hook(2, i * dims + j)] = 2 * rows[hook(1, i * dims + j)];
  }
}