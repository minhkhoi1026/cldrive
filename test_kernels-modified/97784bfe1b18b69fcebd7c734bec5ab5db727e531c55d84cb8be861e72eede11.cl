//{"a":0,"size":1,"value":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fill(global int* a, const int size, const int value) {
  int index = get_global_id(0);
  if (index >= size) {
    return;
  }
  a[hook(0, index)] = 42;
}