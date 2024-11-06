
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void swap1D(global double* data, global int* bitRev) {
  int idX = get_global_id(0);
  double holder;
  int old = 0, new = 0;

  if (idX < bitRev[hook(1, idX)]) {
    old = 2 * idX;
    new = 2 * bitRev[hook(1, idX)];

    holder = data[hook(0, new)];
    data[hook(0, new)] = data[hook(0, old)];
    data[hook(0, old)] = holder;

    holder = data[hook(0, new + 1)];
    data[hook(0, new + 1)] = data[hook(0, old + 1)];
    data[hook(0, old + 1)] = holder;
  }
}