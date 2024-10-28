//{"srcArray":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addCols(global int* srcArray) {
  int gid = get_global_id(0);
  int d = 100;

  if (gid <= d + 1) {
    srcArray[hook(0, gid * (d + 2) + d + 1)] = srcArray[hook(0, gid * (d + 2) + 1)];
    srcArray[hook(0, gid * (d + 2))] = srcArray[hook(0, gid * (d + 2) + d)];
  }
}