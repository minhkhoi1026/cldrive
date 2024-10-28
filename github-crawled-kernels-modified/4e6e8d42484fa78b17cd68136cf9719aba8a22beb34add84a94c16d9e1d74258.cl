//{"a":0,"aColumns":1,"b":2,"bColumns":3,"c":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mulMatDouble(global const double* a, int aColumns, global const double* b, int bColumns, global double* c) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  double total = 0;

  int iAOff = i * aColumns;
  for (int k = 0; k < aColumns; k++) {
    total += a[hook(0, iAOff + k)] * b[hook(2, k * bColumns + j)];
  }
  c[hook(4, i * bColumns + j)] = total;
}