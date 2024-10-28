//{"N":0,"cells":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reset_cells(const unsigned int N, global int* cells) {
  const int globalid = get_global_id(0);
  if (globalid >= N)
    return;

  cells[hook(1, globalid)] = -1;
}