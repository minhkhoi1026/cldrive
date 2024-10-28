//{"N":1,"foundCells":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initCells(global int2* foundCells, const unsigned int N) {
  const unsigned int i = get_global_id(0);
  if (i >= N)
    return;

  foundCells[hook(0, i)].x = -1;
  foundCells[hook(0, i)].y = -1;
}