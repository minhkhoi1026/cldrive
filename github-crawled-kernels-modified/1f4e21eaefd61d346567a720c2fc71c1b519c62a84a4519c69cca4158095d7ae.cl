//{"a":0,"c":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void part1(global int* a, global int* c) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  unsigned int id = i + 5 * j;

  c[hook(1, id)] = a[hook(0, id)] + id;
}