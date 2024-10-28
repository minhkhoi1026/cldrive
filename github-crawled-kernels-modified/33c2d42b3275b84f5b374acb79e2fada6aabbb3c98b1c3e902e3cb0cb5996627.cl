//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void A(global int* a) {
  int id = get_global_id(0);
  while (1)
    a[hook(0, id)] += 1;
}