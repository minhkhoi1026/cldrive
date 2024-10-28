//{"array":1,"n":0,"value":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init_array_value(int n, global int* array, int value) {
  int tid = get_global_id(0);
  if (tid >= n) {
    return;
  }

  array[hook(1, tid)] = value;
}