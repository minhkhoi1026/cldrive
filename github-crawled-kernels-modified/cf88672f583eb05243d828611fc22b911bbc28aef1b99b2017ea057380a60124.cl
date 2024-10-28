//{"a":1,"c":2,"ySize":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ToggleCell(const int ySize, global int* a, global int* c) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  unsigned int id = i + ySize * j;

  if (a[hook(1, id)] == 0) {
    c[hook(2, id)] = 1;
  } else {
    c[hook(2, id)] = 0;
  }
}