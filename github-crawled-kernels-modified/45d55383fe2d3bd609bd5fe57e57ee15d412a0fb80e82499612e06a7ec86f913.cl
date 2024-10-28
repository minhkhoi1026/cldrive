//{"a":0,"aColumns":2,"aRows":1,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transposeDouble(global const double* a, int aRows, int aColumns, global double* out) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  int outColumns = aRows;
  out[hook(3, i * outColumns + j)] = a[hook(0, j * aColumns + i)];
}