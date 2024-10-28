//{"a":0,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void assignArr(global int* a, const int val) {
  const int id = get_global_id(0);
  a[hook(0, id)] = 42;
}