//{"array":0,"ncols":4,"nrows":3,"out":1,"row":5,"row_to_access":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void access2darray(global float* array, global float* out, const int row_to_access, const int nrows, const int ncols) {
  global float* row = &array[hook(0, row_to_access * ncols)];
  for (int i = 0; i < ncols; i++) {
    out[hook(1, i)] = row[hook(5, i)];
  }
}