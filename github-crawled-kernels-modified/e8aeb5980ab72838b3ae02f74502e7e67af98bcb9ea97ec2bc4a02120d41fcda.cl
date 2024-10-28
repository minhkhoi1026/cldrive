//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCode(global int* a) {
  int gi = get_global_id(0);
  int li = get_local_id(0);

  a[hook(0, gi)] = li;
}