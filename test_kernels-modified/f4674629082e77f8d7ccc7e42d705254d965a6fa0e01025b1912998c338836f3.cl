//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_42(const global int* a, global int* b) {
  for (unsigned int i = 0; i < 300; ++i)
    b[hook(1, i)] = a[hook(0, i)] + 42;
}