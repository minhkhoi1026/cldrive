//{"array":0,"n":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ConMemCache(constant int* array, global int* out, int n) {
  int gid = get_global_id(0);
  int i = 0;
  int j = array[hook(0, gid)];

  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];
  j = array[hook(0, j)];

  out[hook(1, 0)] = j;
}